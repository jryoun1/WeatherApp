//
//  ErrorHandling.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/26.
//
import Foundation

enum WeatherError: Error {
    case failGetAuthorization
    case failTransportData
    case failGetData
    case failGetImage
    case failDecode
    case failMakeURL
    case failGetLocation
    case failGetAddress
    case unknown
}
