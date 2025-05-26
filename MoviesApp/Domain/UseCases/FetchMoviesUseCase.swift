//
//  FetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol FetchMoviesUseCase {
    func execute() async throws -> [String: MoviesResponse]
}

class FetchMoviesUseCaseImpl: FetchMoviesUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository = MoviesRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute() async throws -> [String : MoviesResponse] {
        try await repository.fetchAllMovies()
    }
    
}
