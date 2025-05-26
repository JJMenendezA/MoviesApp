//
//  MovieDetailsRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol MovieDetailsRepository {
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse
}

class MovieDetailsRepositoryImpl: MovieDetailsRepository {
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        try await moviesService.fecthMovieDetails(endPoint: endPoint)
    }
}
