//
//  CustomDateFormatter.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/29.
//
import Foundation

struct CustomDateFormatter {
    static let utcFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        return dateFormatter
    }()
}
