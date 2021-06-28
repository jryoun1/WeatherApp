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
    
    func checkLocationAuthorization() {
        switch locationManger.authorizationStatus {
        case .notDetermined, .denied:
            //TODO: - error 처리 필요
            return
        case .authorizedAlways, .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
        default:
            return
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        guard let currentLocation = self.locationManger.location else {
            return nil
        }
        return currentLocation
    }
    
    func convertLocationToAddress(location: CLLocation) -> String? {
        let geoCoder = CLGeocoder()
        var currentAddress: String?
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let _ = error {
                currentAddress = nil
                return
            }
            
            guard let placemark = placemarks?.first,
                  let administrativeArea = placemark.administrativeArea,
                  let locality = placemark.locality else {
                currentAddress = nil
                return
            }
            
            currentAddress = "\(administrativeArea) \(locality)"
        }
        return currentAddress
    }
}
