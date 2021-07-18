//
//  ForecastWeatherData.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import Foundation

struct ForecastWeatherList: Decodable {
    let list: [ForecastWeather]
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case list
        case count = "cnt"
    }
}
