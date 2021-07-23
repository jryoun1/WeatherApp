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
        sutNetworkManager = NetworkManager.shared
        super.setUp()
    }
    
    func testGetAddress() {
        // 1.given
        let currentLocation = CLLocation(latitude: 37.785834, longitude:  -122.406417)
        
        // 2.when
        sutLocationManager.convertLocationToAddress(location: currentLocation)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        
        // 3.then
        XCTAssertEqual(sutLocationManager.currentAddress, "CA 샌프란시스코")
    }
    
    func testGetURL() {
        // 1.given
        let currentLocation = CLLocation(latitude: 37.785834, longitude:  -122.406417)
        let testImageID = "1D"
        let expectedCurrentAPIURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.785834&lon=-122.406417&units=metric&appid=f69d4e7052b5e2f0dd63a6da187d02f5")
        let expectedForecastAPIURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.785834&lon=-122.406417&units=metric&appid=f69d4e7052b5e2f0dd63a6da187d02f5")
        let expectedImageURL = URL(string: "https://openweathermap.org/img/w/1D.png")
        
        // 2.when
        guard let currentAPIURL = ConfigURL.getWeatherURLWith(locationCoordinate: currentLocation.coordinate, api: .current),
              let forecastAPIURL = ConfigURL.getWeatherURLWith(locationCoordinate: currentLocation.coordinate, api: .forecast),
              let imageURL = ConfigURL.getWeatherImageURLWith(imageID: testImageID) else {
            return
        }
        
        // 3.then
        XCTAssertEqual(currentAPIURL, expectedCurrentAPIURL)
        XCTAssertEqual(forecastAPIURL, expectedForecastAPIURL)
        XCTAssertEqual(imageURL, expectedImageURL)
    }
    
    func testGetCurrentWeatherData() {
        // 1.given
        let expectation = XCTestExpectation(description: "APITaskExpectation")
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var currentWeather: CurrentWeather?
        let currentLocation = CLLocation(latitude: 37.785834, longitude:  -122.406417)
        
        // 2.when
        sutNetworkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .current) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    currentWeather = try jsonDecoder.decode(CurrentWeather.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(_):
                return
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // 3.then
        let cityName = currentWeather?.cityName
        XCTAssertEqual(cityName, "San Francisco")
    }
    
    func testGetForecastWeatherData() {
        // 1.given
        let expectation = XCTestExpectation(description: "APITaskExpectation")
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var forecastWeatherList: ForecastWeatherList?
        let currentLocation = CLLocation(latitude: 37.785834, longitude:  -122.406417)
        
        // 2.when
        sutNetworkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .forecast) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    forecastWeatherList = try jsonDecoder.decode(ForecastWeatherList.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(_):
                return
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        // 3.then
        let count = forecastWeatherList?.count
        XCTAssertEqual(count, 40)
    }
    
    func testGetImage() {
        // 1.given
        let expectationForGetImageName = XCTestExpectation(description: "APITaskExpectation")
        let expectationForGetImage = XCTestExpectation(description: "APITaskExpectation")
        let jsonDecoder: JSONDecoder = JSONDecoder()
        var currentWeather: CurrentWeather?
        var image: UIImage?
        let currentLocation = CLLocation(latitude: 37.785834, longitude:  -122.406417)
        
        sutNetworkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .current) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    currentWeather = try jsonDecoder.decode(CurrentWeather.self, from: data)
                    expectationForGetImageName.fulfill()
                } catch {
                    print(error)
                }
            case .failure(_):
                return
            }
        }
        wait(for: [expectationForGetImageName], timeout: 5.0)
        guard let iconName = currentWeather?.weather[0].icon else {
            return
        }
        
        // 2.when
        sutNetworkManager.loadImage(imageID: iconName) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                image = UIImage(data: data)
                expectationForGetImage.fulfill()
            case .failure(_):
                return
            }
        }
        wait(for: [expectationForGetImage], timeout: 5.0)
        
        // 3.then
        XCTAssertNotNil(image)
    }
    
    override func tearDown() {
        sutLocationManager = nil
        sutNetworkManager = nil
        super.tearDown()
    }
}
