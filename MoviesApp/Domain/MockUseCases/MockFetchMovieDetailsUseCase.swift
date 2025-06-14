//
//  MockFetchMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository = MockMoviesRepository()) {
        self.repository = repository
    }
    
    func fetch(endPoint: String) async throws -> MovieDetailsResponse {
        try await repository.fecthMovieDetails(endPoint: endPoint)
    }
}
