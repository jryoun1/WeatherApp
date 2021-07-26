//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import UIKit
import CoreLocation

final class LocationManager {
    let locationManger = CLLocationManager()
    var currentAddress: String?
    
    func requestAuthorization() {
        locationManger.requestWhenInUseAuthorization()
    }
    
    func configureLocationManager(viewController: UIViewController) {
        locationManger.delegate = viewController as? CLLocationManagerDelegate
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() throws {
        switch locationManger.authorizationStatus {
        case .denied:
            throw WeatherError.failGetAuthorization
        case .authorizedAlways, .authorizedWhenInUse:
            locationManger.requestLocation()
        default:
            return
        }
    }
    
    func convertLocationToAddress(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil {
                return
            }
            
            guard let placemark = placemarks?.first,
                  let administrativeArea = placemark.administrativeArea,
                  let locality = placemark.locality else {
                return
            }
            self.currentAddress = "\(administrativeArea) \(locality)"
        }
    }
}
