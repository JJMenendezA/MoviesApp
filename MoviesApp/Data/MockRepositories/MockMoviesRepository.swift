//
//  MockMoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockMoviesRepository: MoviesRepository {
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MockMoviesService()) {
        self.moviesService = moviesService
    }
    
    func fetchAllMovies() async throws -> [String: MoviesResponse] {
        try await moviesService.fetchAllMovies()
    }
    
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        try await moviesService.fecthMovieDetails(endPoint: endPoint)
    }
    
}
