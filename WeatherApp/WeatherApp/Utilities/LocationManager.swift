//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import UIKit
import CoreLocation

final class LocationManager {
    public typealias resultHandler = (Result<[CLPlacemark]?, WeatherError>) -> Void
    let locationManger = CLLocationManager()
    var currentAddress: String?
    
    func requestAuthorization() {
        locationManger.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorization() throws {
        switch locationManger.authorizationStatus {
        case .notDetermined, .denied:
            throw WeatherError.failGetAuthorization
        case .authorizedAlways, .authorizedWhenInUse:
            locationManger.startUpdatingLocation()
        default:
            throw WeatherError.unknown
        }
    }
    
    func convertCoordinateToAddress(completion: @escaping resultHandler) {
        if let lastLocation = self.locationManger.location {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) -> Void in
                if let _ = error {
                    return completion(.failure(.failGetLocation))
                }
                
                guard let placemark = placemarks?.first,
                      let administrativeArea = placemark.administrativeArea,
                      let locality = placemark.locality else {
                    return completion(.failure(.failGetAddress))
                }
                
                self.currentAddress = "\(administrativeArea) \(locality)"
            }
        }
    }
}
