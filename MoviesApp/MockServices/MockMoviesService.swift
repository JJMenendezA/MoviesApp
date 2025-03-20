//
//  MockNetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

class MockMoviesService: MoviesServiceProtocol {
    var shouldFail: Bool = false

    func fetchAllMovies(completion: @escaping (Result<[String: Movies], AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            var moviesList: [String: Movies] = [:]
            moviesList["popular"] = Movies(dates: nil,
                                           page: 1,
                                           results: [dummyMovieInfo],
                                           total_pages: 5,
                                           total_results: 100)
            completion(.success(moviesList))
        }
    }

    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            completion(.success(Movies(dates: nil,
                                       page: 1,
                                       results: [dummyMovieInfo],
                                       total_pages: 5,
                                       total_results: 100)))
        }
    }

    func fetchMovieDetails(endPoint: String, completion: @escaping (Result<MovieDetails, AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            completion(.success(dummyDetailsMovieInfo))
        }
    }
}
