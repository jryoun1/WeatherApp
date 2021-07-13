//
//  UIViewController+Error.swift
//  WeatherApp
//
//  Created by Yeon on 2021/07/13.
//

import UIKit

extension UIViewController {
    private func showAlert(about error: WeatherError) {
        let alert = UIAlertController(title: "에러 발생",
                                      message: "\(error.localizedDescription) 앱을 다시 실행해주세요",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleError(from error: WeatherError) {
        switch error {
        case .failGetLocation:
            DispatchQueue.main.async {
                self.showAlert(about: .failGetLocation)
            }
        case .failGetAuthorization:
            DispatchQueue.main.async {
                self.showAlert(about: .failGetAuthorization)
            }
        case .failTransportData:
            DispatchQueue.main.async {
                self.showAlert(about: .failTransportData)
            }
        case .failGetData:
            DispatchQueue.main.async {
                self.showAlert(about: .failGetData)
            }
        case .failGetImage:
            DispatchQueue.main.async {
                self.showAlert(about: .failGetImage)
            }
        case .failDecode:
            DispatchQueue.main.async {
                self.showAlert(about: .failDecode)
            }
        case .failMakeURL:
            DispatchQueue.main.async {
                self.showAlert(about: .failMakeURL)
            }
        case .failGetAddress:
            DispatchQueue.main.async {
                self.showAlert(about: .failGetAddress)
            }
        case .unknown:
            DispatchQueue.main.async {
                self.showAlert(about: .unknown)
            }
        }
    }
}
