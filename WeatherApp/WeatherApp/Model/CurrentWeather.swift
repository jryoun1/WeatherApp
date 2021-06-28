//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import Foundation

struct CurrentWeather: Decodable {
    let weather: [Weather]
    let temperature: Temperature
    let timezone: Date
    let cityName: String
    
    enum codingKeys: String, CodingKey {
        case weather, timezone
        case cityName = "name"
        case temperature = "main"
    }
}
