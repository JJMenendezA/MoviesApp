//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 24/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol MoviesService {
    func fetchAllMovies() async throws -> [String: MoviesResponse]
    func fetchMovies(endpoint: String) async throws -> MoviesResponse
    func fetchMovieDetails(endPoint: String) async throws -> MovieDetailsResponse
}

class MoviesServiceImpl: MoviesService {
    private let networkManager: NetworkManager
    private let languageProvider: @MainActor () -> String
    
    init(networkManager: NetworkManager = NetworkManager.shared,
         languageProvider: @escaping @MainActor () -> String) {
        self.networkManager = networkManager
        self.languageProvider = languageProvider
    }
    
    func fetchAllMovies() async throws -> [String: MoviesResponse] {
        var moviesList: [String: MoviesResponse] = [:]
        
        for type in MovieTypes.allCases {
            moviesList[type.title] = try await fetchMovies(endpoint: type.endpoint)
        }
        return moviesList
    }
    
    func fetchMovies(endpoint: String)  async throws -> MoviesResponse {
        let currentLanguage = await MainActor.run { languageProvider() }
        return try await networkManager.getMoviesRequest(endpoint: endpoint,
        queryItems: [URLQueryItem(name: "language",
                                  value: currentLanguage),
                     URLQueryItem(name: "page",
                                  value: "1")],
        response: MoviesResponse.self)
    }
    
    func fetchMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        let currentLanguage = await MainActor.run { languageProvider() }
        return try await networkManager.getMoviesRequest(endpoint: endPoint,
                                                  queryItems: [URLQueryItem(name: "append_to_response",
                                                                            value: "videos,similar"),
                                                               URLQueryItem(name: "language",
                                                                            value: currentLanguage)],
                                                  response: MovieDetailsResponse.self)
    }
}
