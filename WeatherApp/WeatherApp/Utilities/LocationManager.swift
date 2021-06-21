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
}
