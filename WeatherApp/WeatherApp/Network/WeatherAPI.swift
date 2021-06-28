//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/22.
//

import Foundation

enum WeatherAPI {
    case current
    case forecast
}

extension WeatherAPI: CustomStringConvertible {
    var description: String {
        switch self {
        case .current:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }
}
