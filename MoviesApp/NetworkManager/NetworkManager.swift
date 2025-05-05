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
        response: T.Type) async throws -> T {
            
            guard let baseMovieURL = URL(string: "https://api.themoviedb.org/3") else {
                throw AppError.invalidURL
            }
            
            let url = baseMovieURL.appendingPathComponent(endpoint)
            
            print("-------------URL-------------------")
            print(url.absoluteString)
            
            guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw AppError.invalidURL
            }
            
            if let queryItems = queryItems {
                components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
            }
            
            guard let componentsURL = components.url else {
                throw AppError.invalidURL
            }
            
            var request = URLRequest(url: componentsURL)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "Authorization": "Bearer \(APIKey)"
            ]
            
            let (data, response) =  try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                throw AppError.invalidResponse(statusCode: statusCode)
            }
            
            print("-------------HTTP Response-------------------")
            print(httpResponse)
            
            print("---------------Data-----------------")
            if let dataString = String(bytes: data, encoding: .utf8) {
                print(dataString)
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                print("--------------Decoded Object------------------")
                print(decodedObject)
                return decodedObject
            } catch {
                throw AppError.decodingError
            }
        }
}
