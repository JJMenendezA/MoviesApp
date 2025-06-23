//
//  MockNetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

class MockMoviesService: MoviesService {
    var shouldFail: Bool = false
    
    func fetchAllMovies() async throws -> [String: MoviesResponse] {
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
    
    func fetchMovies(endpoint: String)  async throws -> MoviesResponse {
        if shouldFail {
            throw AppError.noData
        } else {
            return MoviesResponse(dates: nil,
                                  page: 1,
                                  results: [dummyMovieResponse],
                                  total_pages: 5,
                                  total_results: 100)
        }
    }
    
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse {
        if shouldFail {
            throw AppError.noData
        } else {
            return dummyDetailsMovieInfo
        }
    }
}
