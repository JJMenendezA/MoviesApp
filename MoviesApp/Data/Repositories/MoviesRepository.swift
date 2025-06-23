//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol MoviesRepository {
    func fetchMovies() async throws -> [String: MoviesResponse]
    func fetchDetails(endPoint: String) async throws -> MovieDetailsResponse
}

class MoviesRepositoryImpl: MoviesRepository {
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    func fetchMovies() async throws -> [String: MoviesResponse] {
        try await moviesService.fetchAllMovies()
    }
    
    func fetchDetails(endPoint: String) async throws -> MovieDetailsResponse {
        try await moviesService.fecthMovieDetails(endPoint: endPoint)
    }
}
