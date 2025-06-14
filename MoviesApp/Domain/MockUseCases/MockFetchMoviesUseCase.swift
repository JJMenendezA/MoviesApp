//
//  MockFetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockFetchMoviesUseCase: FetchMoviesUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository = MockMoviesRepository()) {
        self.repository = repository
    }
    
    func fetch() async throws -> [String: MoviesResponse] {
        try await repository.fetchAllMovies()
    }
}
