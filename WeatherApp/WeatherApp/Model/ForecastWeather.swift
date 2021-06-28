//
//  Weathers.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import Foundation

struct ForecastWeather: Decodable {
    let timezone: Date
    let temperature: Temperature
    let weather: [Weather]
    
    enum codingKeys: String, CodingKey {
        case weather
        case timezone = "dt"
        case temperature = "main"
    }
}
