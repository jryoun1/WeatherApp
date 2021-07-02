//
//  WeatherTableViewHeaderView.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/30.
//

import UIKit

final class WeatherTableViewHeaderView: UITableViewHeaderFooterView {
    private var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var mininumAndMaximumTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupHeaderView() {
        verticalStackView.addArrangedSubview(addressLabel)
        verticalStackView.addArrangedSubview(mininumAndMaximumTemperatureLabel)
        verticalStackView.addArrangedSubview(currentTemperatureLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(verticalStackView)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            weatherImageView.widthAnchor.constraint(equalToConstant: 100),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            verticalStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 5),
            verticalStackView.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupHeaderViewData(data: CurrentWeather, address: String) {
        addressLabel.text = address
        mininumAndMaximumTemperatureLabel.text = "최저 \(data.temperature.minimum)° 최고 \(data.temperature.maximum)°"
        currentTemperatureLabel.text = "\(data.temperature.current)°"
    }
}
