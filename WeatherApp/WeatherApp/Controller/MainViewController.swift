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
    private var currentWeather: CurrentWeather? = try? JSONDecoder().decode(CurrentWeather.self, from: NSDataAsset(name:"CurrentWeather")!.data)
    private var forecastWeatherList: ForecastWeatherList? = try? JSONDecoder().decode(ForecastWeatherList.self, from: NSDataAsset(name:"5DayWeatherForecast")!.data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setupWeatherTableView()
        setupRefresh()
    }
    
    private func configureLocationManager() {
        locationManager.configureLocationManager(viewController: self)
        locationManager.requestAuthorization()
        do {
            try locationManager.checkLocationAuthorization()
        } catch(let error) {
            handleError(from: error as! WeatherError)
        }
    }
    
    private func setupWeatherTableView() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.allowsSelection = false
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.cellID)
        weatherTableView.register(WeatherTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WeatherTableViewHeaderView.headerViewID)
        
        configureWeatherTableViewBackgroundView()
        configureWeatherTableViewLayout()
    }
    
    private func configureWeatherTableViewBackgroundView() {
        weatherTableView.backgroundView = UIImageView(image: UIImage(named: "weatherAppBackground"))
        weatherTableView.backgroundView?.alpha = 0.8
    }
    
    private func configureWeatherTableViewLayout() {
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherTableView)
        NSLayoutConstraint.activate([
            weatherTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherTableView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupRefresh() {
        let refresh: UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
        refresh.tintColor = .gray
        weatherTableView.refreshControl = refresh
    }
    
    @objc private func updateUI(refresh: UIRefreshControl) {
        locationManager.requestAuthorization()
        refresh.endRefreshing()
        weatherTableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeatherList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellID, for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        if let forecastWeatherData = forecastWeatherList?.list[indexPath.row],
           let imageID = forecastWeatherData.weather.first?.icon {
            weatherTableViewCell.setupCellData(data: forecastWeatherData)
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: weatherTableViewCell){
                    if index.row == indexPath.row {
                        weatherTableViewCell.weatherImageView.loadImage(imageID)
                    }
                }
            }
        }
        
        weatherTableViewCell.backgroundColor = .clear
        return weatherTableViewCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let weatherTableViewHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WeatherTableViewHeaderView.headerViewID) as? WeatherTableViewHeaderView else {
            return UIView()
        }
        
        if let currentWeatherData = currentWeather,
           let imageID = currentWeatherData.weather.first?.icon {
            
            if let currentAddress = locationManager.currentAddress {
                weatherTableViewHeaderView.setupHeaderViewData(data: currentWeatherData, address: currentAddress)
            } else {
                weatherTableViewHeaderView.setupHeaderViewData(data: currentWeatherData, address: "CA San Francisco")
            }
            
            DispatchQueue.main.async {
                weatherTableViewHeaderView.weatherImageView.loadImage(imageID)
            }
        }
        
        return weatherTableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
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
        
        networkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .current) { [weak self] result in
            switch result {
            case .success(let data):
                guard let currentWeatherData = data else {
                    return
                }
                do {
                    self?.currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: currentWeatherData)
                    DispatchQueue.main.async {
                        self?.weatherTableView.reloadSections([0,0], with: .none)
                    }
                } catch {
                    self?.handleError(from: .failDecode)
                }
            case .failure:
                self?.handleError(from: .failGetData)
            }
        }
        
        networkManager.loadData(locationCoordinate: currentLocation.coordinate, api: .forecast) { [weak self] result in
            switch result {
            case .success(let data):
                guard let forecastWeatherListData = data else {
                    return
                }
                do {
                    self?.forecastWeatherList = try JSONDecoder().decode(ForecastWeatherList.self, from: forecastWeatherListData)
                    DispatchQueue.main.async {
                        self?.weatherTableView.reloadSections(IndexSet(integer: 0), with: .none)
                    }
                } catch {
                    self?.handleError(from: .failDecode)
                }
            case .failure:
                self?.handleError(from: .failGetData)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        do {
            try locationManager.checkLocationAuthorization()
        } catch(let error) {
            handleError(from: error as! WeatherError)
        }
    }
}
