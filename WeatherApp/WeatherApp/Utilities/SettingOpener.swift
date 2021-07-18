//
//  SettingOpener.swift
//  WeatherApp
//
//  Created by Yeon on 2021/07/14.
//

import UIKit

protocol URLOpening {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: URLOpening { }

final class SettingOpener {
    private var openSettingsURLString: String
    private let urlOpener: URLOpening
    
    init(urlOpener: URLOpening = UIApplication.shared, openSettingsURLString: String = UIApplication.openSettingsURLString) {
        self.urlOpener = urlOpener
        self.openSettingsURLString = openSettingsURLString
    }
    
    func open() {
        if let url = URL(string: self.openSettingsURLString) {
            urlOpener.open(url, options: [:], completionHandler: nil)
        }
    }
}
