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
                self.showAuthorizationAlert(about: .failGetAuthorization)
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
    
    //MARK: - LocationAuthorizationRequest fail
    private func showAuthorizationAlert(about error: WeatherError) {
        let alert = UIAlertController(title: nil,
                                      message: "\(error.localizedDescription)\n위치 정보를 허용해야만 날씨 데이터를 받아올 수 있습니다.\n설정화면으로 이동할까요?",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "이동", style: .default) { _ in
            //openSetting 
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
