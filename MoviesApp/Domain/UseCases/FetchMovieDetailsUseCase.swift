//
//  FetchMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol FetchMovieDetailsUseCase {
    func fetch(endPoint: String) async throws -> MovieDetailsResponse
}

class FetchMovieDetailsImpl: FetchMovieDetailsUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func fetch(endPoint: String) async throws -> MovieDetailsResponse {
        try await repository.fetchDetails(endPoint: endPoint)
    }
}
