//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 24/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol MoviesServiceProtocol {
    func fetchAllMovies() async throws -> [String: MoviesResponse]
    func fetchMovies(endpoint: String) async throws -> MoviesResponse
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse
}

class MoviesService: MoviesServiceProtocol {
    private let networkManager: NetworkManager
    private let language: String = NSLocale.current.language.languageCode?.identifier ?? "en-US"
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchAllMovies() async throws -> [String: MoviesResponse] {
        var moviesList: [String: MoviesResponse] = [:]
        
        for type in MovieTypes.allCases {
            moviesList[type.title] = try await fetchMovies(endpoint: type.endpoint)
        }
        return moviesList
    }
    
    func fetchMovies(endpoint: String)  async throws -> MoviesResponse {
        try await networkManager.getMoviesRequest(endpoint: endpoint,
        queryItems: [URLQueryItem(name: "language",
                                  value: language),
                     URLQueryItem(name: "page",
                                  value: "1")],
        response: MoviesResponse.self)
    }
    
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        try await networkManager.getMoviesRequest(endpoint: endPoint,
                                                  queryItems: [URLQueryItem(name: "append_to_response",
                                                                            value: "videos,similar"),
                                                               URLQueryItem(name: "language",
                                                                            value: language)],
                                                  response: MovieDetailsResponse.self)
    }
}
