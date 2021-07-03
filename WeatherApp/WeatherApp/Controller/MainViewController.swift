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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherTableView()
    }
    
    private func setupWeatherTableView() {
        weatherTableView.delegate = self
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
