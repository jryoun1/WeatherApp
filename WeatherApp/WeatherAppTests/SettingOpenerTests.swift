//
//  SettingOpenerTests.swift
//  WeatherAppTests
//
//  Created by Yeon on 2021/07/23.
//

import XCTest
@testable import WeatherApp

final class SettingOpenerTests: XCTestCase {
    var urlOpener: MockURLOpener!
    
    override func setUpWithError() throws {
        urlOpener = MockURLOpener()
    }
    
    func testSettingOpenerWhenWrongURLGiven() {
        let settingOpener = SettingOpener(urlOpener: urlOpener, openSettingsURLString: "app-setting:")
        settingOpener.open()
        
        XCTAssertNotEqual(urlOpener.opendURL, URL(string: "app-settings:"))
    }
    
    override func tearDownWithError() throws {
        urlOpener = nil
    }
}

final class MockURLOpener: URLOpening {
    var opendURL: URL?
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
        opendURL = url
    }
}
