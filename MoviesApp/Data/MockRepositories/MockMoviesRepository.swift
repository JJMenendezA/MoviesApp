//
//  MockMoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockMoviesRepository: MoviesRepository {
    private let moviesService: MoviesService
    var shouldFail: Bool = false
    init(moviesService: MoviesService = MockMoviesService()) {
        self.moviesService = moviesService
    }
    
    func fetchMovies() async throws -> [String: MoviesResponse] {
        if shouldFail {
            throw AppError.noData
        } else {
            return ["popular": MoviesResponse(dates: nil,
                                              page: 1,
                                              results: [dummyMovieResponse],
                                              total_pages: 5,
                                              total_results: 100)]
        }
    }
    
    func fetchDetails(endPoint: String) async throws -> MovieDetailsResponse {
        if shouldFail {
            throw AppError.noData
        } else {
            return dummyDetailsMovieInfo
        }
    }
}
