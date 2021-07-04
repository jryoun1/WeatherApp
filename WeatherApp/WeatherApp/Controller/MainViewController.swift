//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import UIKit
import CoreLocation

final class MainViewController: UIViewController {
    private let weatherTableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let locationManager = LocationManager()
    private let networkManager = NetworkManager()
    private var currentWeather: CurrentWeather?
    private var forecastWeatherList: ForecastWeatherList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setupWeatherTableView()
    }
    
    private func configureLocationManager() {
        locationManager.configureLocationManager(viewController: self)
        locationManager.requestAuthorization()
        do {
            try locationManager.checkLocationAuthorization()
        } catch(let error) {
            //TODO: Error 처리 필요
            print(error)
        }
    }
    
    private func setupWeatherTableView() {
        weatherTableView.dataSource = self
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.cellID)
        weatherTableView.register(WeatherTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherTableViewHeaderView.headerViewID)
        
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherTableView)
        NSLayoutConstraint.activate([
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeatherList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellID, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        return weatherTableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let weatherTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherTableViewHeaderView.headerViewID) as? WeatherTableViewHeaderView else {
            return UIView()
        }
        
        return weatherTableViewHeaderView
    }
}

// MARK: Extension - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        locationManager.locationManger.stopUpdatingLocation()
        locationManager.convertLocationToAddress(location: currentLocation)
        
        networkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .current) { result in
            switch result {
            case .success(let data):
                guard let currentWeatherData = data else {
                    return
                }
                do {
                    self.currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: currentWeatherData)
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadSections([0,0], with: .none)
                    }
                } catch(let error) {
                    //TODO: Error 처리 필요
                    print(error)
                }
            case .failure(let error):
                //TODO: Error 처리 필요
                print(error)
            }
        }
        
        networkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .forecast) { result in
            switch result {
            case .success(let data):
                guard let forecastWeatherListData = data else {
                    return
                }
                do {
                    self.forecastWeatherList = try JSONDecoder().decode(ForecastWeatherList.self, from: forecastWeatherListData)
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                } catch(let error) {
                    //TODO: Error 처리 필요
                    print(error)
                }
            case .failure(let error):
                //TODO: Error 처리 필요
                print(error)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        do {
            try locationManager.checkLocationAuthorization()
        } catch(let error) {
            //TODO: Error 처리 필요
            print(error)
        }
    }
}
