//
//  MockNetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation


class MockMoviesService: MoviesServiceProtocol {
    func fetchAllMovies(completion: @escaping (Result<[String : Movies], any Error>) -> Void) {
         if shouldFail {
             completion(.failure(AppError.noData))
         } else {
             var moviesList: [String : Movies] = [:]
             moviesList["popular"] = Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)
             
             completion(.success(moviesList))
         }
    }
    
    var shouldFail: Bool = false
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, any Error>) -> Void) {
        if shouldFail {
            completion(.failure(AppError.noData))
        } else {
            completion(.success(Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)))
        }
    }
}

let dummyMovieInfo: MovieInfo = MovieInfo(adult: false, backdrop_path: "", genre_ids: [], id: 0, original_language: "", original_title: "", overview: "", popularity: 0.0, poster_path: "/gCI2AeMV4IHSewhJkzsur5MEp6R.jpg", release_date: "", title: "Cinema Paradiso", video: false, vote_average: 0.0, vote_count: 0)
