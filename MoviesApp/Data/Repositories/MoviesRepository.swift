//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol MoviesRepository {
    func fetchAllMovies() async throws -> [String: MoviesResponse]
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse
}

class MoviesRepositoryImpl: MoviesRepository {
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MoviesServiceImpl()) {
        self.moviesService = moviesService
    }
    
    func fetchAllMovies() async throws -> [String: MoviesResponse] {
        try await moviesService.fetchAllMovies()
    }
    
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        try await moviesService.fecthMovieDetails(endPoint: endPoint)
    }
}
