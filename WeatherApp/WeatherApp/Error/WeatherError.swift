//
//  ErrorHandling.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/26.
//
import Foundation

enum WeatherError: Error {
    case failGetAuthorization
    case failTransportData
    case failGetData
    case failGetImage
    case failDecode
    case failMakeURL
    case failGetLocation
    case failGetAddress
    case unknown
}

extension WeatherError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failGetAuthorization:
            return "사용자로부터 권한을 얻는데 실패했습니다."
        case .failMakeURL:
            return "URL을 생성하는데 실패했습니다."
        case .failTransportData:
            return "서버로 데이터를 전송하는데 실패했습니다."
        case .failGetData:
            return "데이터를 서버로부터 가져오는데 실패했습니다."
        case .failGetImage:
            return "이미지를 서버로부터 가져오는데 실패했습니다."
        case .failDecode:
            return "데이터를 디코딩하는데 실패했습니다."
        case .failGetLocation:
            return "위치 정보를 가져오는데 실패했습니다."
        case .failGetAddress:
            return "위치를 주소로 바꾸는데 실패했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
