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
    typealias resultHandler = (Result<String?, WeatherError>) -> Void
    
    func requestAuthorization() {
        locationManger.requestWhenInUseAuthorization()
    }
    
    func configureLocationManager(viewController: UIViewController) {
        locationManger.delegate = viewController as? CLLocationManagerDelegate 
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
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
    
    func getCurrentLocation() -> CLLocation? {
        guard let currentLocation = self.locationManger.location else {
            return nil
        }
        return currentLocation
    }
    
    func convertLocationToAddress(location: CLLocation, completion: @escaping resultHandler) {
        let geoCoder = CLGeocoder()
        var currentAddress: String?
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if error != nil {
                return completion(.failure(.failGetLocation))
            }
            
            guard let placemark = placemarks?.first,
                  let administrativeArea = placemark.administrativeArea,
                  let locality = placemark.locality else {
                return completion(.failure(.failGetAddress))
            }
            currentAddress = "\(administrativeArea) \(locality)"
            return completion(.success(currentAddress))
        }
    }
}
