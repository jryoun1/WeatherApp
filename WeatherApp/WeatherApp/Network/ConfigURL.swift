//
//  ConfigURL.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/22.
//

import UIKit
import CoreLocation

enum ConfigURL {
    static let weatherAPIBaseURL = "https://api.openweathermap.org/data/2.5/"
    static let weatherImageBaseURL = "https://openweathermap.org/img/w/"
    static let appID = "f69d4e7052b5e2f0dd63a6da187d02f5"
    static let units = "metric"
    
    static func getWeatherURLWith(locationCoordinate: CLLocationCoordinate2D, api: WeatherAPI) -> URL? {
        var components = URLComponents(string: weatherAPIBaseURL)
        components?.path += api.description
        
        let latitude = URLQueryItem(name: "lat", value: "\(locationCoordinate.latitude)")
        let longtitude = URLQueryItem(name: "lon", value: "\(locationCoordinate.longitude)")
        let units = URLQueryItem(name: "units", value: ConfigURL.units)
        let appID = URLQueryItem(name: "appid", value: ConfigURL.appID)
        components?.queryItems = [latitude, longtitude, units, appID]
        
        return components?.url
    }
    
    static func getWeatherImageURLWith(imageID: String) -> URL? {
        var components = URLComponents(string: weatherImageBaseURL)
        components?.path += "\(imageID).png"
        
        return components?.url
    }
}
