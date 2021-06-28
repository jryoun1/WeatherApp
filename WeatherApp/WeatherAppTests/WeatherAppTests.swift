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
    
    func testGetAddress() {
        // 1.given
        let expectation = XCTestExpectation(description: "geoCoderTaskExpectation")
        var currentAddress: String?
        guard let currentLocation = sutLocationManager.getCurrentLocation() else {
            return
        }
        
        // 2.when
        sutLocationManager.convertLocationToAddress(location: currentLocation) { result in
            switch result {
            case .success(let address):
                currentAddress = address
                expectation.fulfill()
            case .failure(_):
                return
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // 3.then
        XCTAssertEqual(currentAddress, "CA San Francisco")
    }
    
    override func tearDown() {
        sutLocationManager = nil
        sutNetworkManager = nil
        super.tearDown()
    }
}
