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

}
