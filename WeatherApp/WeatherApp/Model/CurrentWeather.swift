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
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case cityName = "name"
        case temperature = "main"
    }
}
