//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/22.
//

import UIKit
import CoreLocation

struct NetworkManager {
    let urlSession: URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    typealias resultHandler = (Result<Data?, WeatherError>) -> Void
    
    func loadData(locationCoordinate: CLLocationCoordinate2D, api: WeatherAPI, completion: @escaping resultHandler) {
        guard let url = ConfigURL.getWeatherURLWith(locationCoordinate: locationCoordinate, api: api) else {
            return completion(.failure(.failMakeURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        communicateToServer(with: request, completion: completion)
    }
    
    func loadImage(imageID: String, completion: @escaping resultHandler) {
        guard let url = ConfigURL.getWeatherImageURLWith(imageID: imageID) else {
            return completion(.failure(.failMakeURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        communicateToServer(with: request, completion: completion)
    }
    
    private func communicateToServer(with request: URLRequest, completion: @escaping resultHandler) {
        let dataTask: URLSessionDataTask = urlSession.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let _ = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failGetData))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
}
