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
}
