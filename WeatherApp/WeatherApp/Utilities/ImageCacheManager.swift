//
//  ImageCacheManager.swift
//  WeatherApp
//
//  Created by Yeon on 2021/07/17.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
