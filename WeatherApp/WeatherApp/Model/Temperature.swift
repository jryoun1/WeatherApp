//
//  Temperature.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import Foundation

struct Temperature: Decodable {
    let minimum: Double
    let maximum: Double
    let current: Double
    
    enum CodingKeys: String, CodingKey {
        case current = "temp"
        case minimum = "temp_min"
        case maximum = "temp_max"
    }
}
