//
//  SettingOpenerTests.swift
//  WeatherAppTests
//
//  Created by Yeon on 2021/07/23.
//

import XCTest
@testable import WeatherApp

final class SettingOpenerTests: XCTestCase {

}

final class MockURLOpener: URLOpening {
    var opendURL: URL?
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        opendURL = url
    }
}
