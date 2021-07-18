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

extension UIImageView {
    func loadImage(_ imageID: String) {
        let cacheKey = NSString(string: imageID)
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        NetworkManager.shared.loadImage(imageID: imageID) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self?.image = image
                    }
                }
            case .failure:
                self.image = UIImage()
                return
            }
        }
    }
}
