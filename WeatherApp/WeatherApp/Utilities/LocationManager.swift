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
    
    func convertCoordinateToAddress() {
        if let lastLocation = self.locationManger.location {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) -> Void in
                guard let error = error else {
                    //TODO: error 처리 필요
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let administrativeArea = placemark.administrativeArea,
                      let locality = placemark.locality else {
                    //TODO: error 처리 필요
                    return
                }
                
                self.currentAddress = "\(administrativeArea) \(locality)"
            }
        }
    }
}
