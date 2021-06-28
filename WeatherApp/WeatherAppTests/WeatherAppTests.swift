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
    
    func testGetLocation() {
        // 1.given
        var currentLocation: CLLocation?
        
        // 2.when
        currentLocation = sutLocationManager.getCurrentLocation()
        guard let current = currentLocation else {
            return
        }
        
        // 3.then
        XCTAssertEqual(current.coordinate.latitude, 37.785834)
        XCTAssertEqual(current.coordinate.longitude, -122.406417)
    }
    
    override func tearDown() {
        sutLocationManager = nil
        sutNetworkManager = nil
        super.tearDown()
    }
}
