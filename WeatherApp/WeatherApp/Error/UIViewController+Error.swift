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
}
