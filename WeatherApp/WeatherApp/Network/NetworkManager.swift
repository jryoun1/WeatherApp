//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Yeon on 2021/06/22.
//

import UIKit
import CoreLocation

struct NetworkManager {
    typealias resultHandler = (Result<Data?, Error>) -> Void
    
    func loadData(locationCoordinate: CLLocationCoordinate2D, api: WeatherAPI, completion: @escaping resultHandler) {
        guard let url = ConfigURL.getWeatherURLWith(locationCoordinate: locationCoordinate, api: api) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        communicateToServer(with: request, completion: completion)
    }
    
    private func communicateToServer(with request: URLRequest, completion: @escaping resultHandler) {
            let session: URLSession = URLSession.shared
            let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    return completion(.failure(Error))
                }
                
                guard let data = data else {
                    return completion(.failure(Error))
                }
                return completion(.success(data))
            }
            dataTask.resume()
        }
}
