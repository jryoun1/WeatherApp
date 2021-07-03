//
//  ViewController.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/21.
//

import UIKit

final class MainViewController: UIViewController {
    private let weatherTableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var currentWeather: CurrentWeather?
    private var forecastWeatherList: ForecastWeatherList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherTableView()
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
}
