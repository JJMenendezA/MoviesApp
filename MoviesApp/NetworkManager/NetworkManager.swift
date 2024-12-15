//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 18/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation


class NetworkManager {
    static let shared = NetworkManager()
    
    func getMoviesRequest<T: Decodable>(
        endpoint: String,
        queryItems: [URLQueryItem]?,
        response: T.Type,
        completion: @escaping (Result<T, AppError>) -> Void
    ){
        let url = baseMoviesURL.appendingPathComponent(endpoint)
        
        print("-------------URL-------------------")
        print(url.absoluteString)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let queryItems = queryItems {
            components!.queryItems = components?.queryItems.map { $0 + queryItems } ?? queryItems
        }
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(API_Key)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.unknown(localizedDesciption: error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(.invalidResponse(statusCode: statusCode)))
                return
            }
            print("-------------HTTP Response-------------------")
            print(httpResponse)
            
            guard let data = data else {
                completion(.failure(AppError.noData))
                return
            }
            
            print("---------------Data-----------------")
            print(String(decoding: data, as: UTF8.self))
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                print("--------------Decoded Object------------------")
                print(decodedObject)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
