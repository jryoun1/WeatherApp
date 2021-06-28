//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Yeon on 2021/06/21.
//

import XCTest
import CoreLocation
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {
    private var sutLocationManager: LocationManager!
    private var sutNetworkManager: NetworkManager!
    
    override func setUp() {
        sutLocationManager = LocationManager()
        sutNetworkManager = NetworkManager()
        super.setUp()
    }

    override func tearDown() {
        sutLocationManager = nil
        sutNetworkManager = nil
        super.tearDown()
    }
}
