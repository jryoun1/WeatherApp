//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/29.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    static let cellID = "WeatherTableViewCell"
    private var dateTimeLabel: UILabel = {
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
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWeatherTableViewCell()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupWeatherTableViewCell() {
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(currentTemperatureLabel)
        contentView.addSubview(weatherImageView)
    }
    
    private func configureLayout() {
        dateTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateTimeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        currentTemperatureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        currentTemperatureLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            dateTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: dateTimeLabel.trailingAnchor),
            currentTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            weatherImageView.leadingAnchor.constraint(equalTo: currentTemperatureLabel.trailingAnchor, constant: 10),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherImageView.widthAnchor.constraint(equalToConstant: 35),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func setupCellData(data: ForecastWeather) {
        let stringDateTime = CustomDateFormatter.utcFormatter.string(from: data.timezone)
        dateTimeLabel.text = stringDateTime
        
        let stringCurrentTemperature = data.temperature.current
        currentTemperatureLabel.text = "\(stringCurrentTemperature)°"
    }
    
    override func prepareForReuse() {
        dateTimeLabel.text = nil
        currentTemperatureLabel.text = nil
        weatherImageView.image = nil
    }
}
