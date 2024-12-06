//
//  MockNetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation


class MockMoviesService: MoviesServiceProtocol {
    func fetchAllMovies(completion: @escaping (Result<[String : Movies], AppError>) -> Void) {
         if shouldFail {
             completion(.failure(.noData))
         } else {
             var moviesList: [String : Movies] = [:]
             moviesList["popular"] = Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)
             
             completion(.success(moviesList))
         }
    }
    
    var shouldFail: Bool = false
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            completion(.success(Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)))
        }
    }
}

let dummyMovieInfo: MovieInfo = MovieInfo(adult: false, backdrop_path: Optional("/18TSJF1WLA4CkymvVUcKDBwUJ9F.jpg"), genre_ids: [27, 53], id: 1034541, original_language: "en", original_title: "Terrifier 3", overview: "Five years after surviving Art the Clown\'s Halloween massacre, Sienna and Jonathan are still struggling to rebuild their shattered lives. As the holiday season approaches, they try to embrace the Christmas spirit and leave the horrors of the past behind. But just when they think they\'re safe, Art returns, determined to turn their holiday cheer into a new nightmare. The festive season quickly unravels as Art unleashes his twisted brand of terror, proving that no holiday is safe.", popularity: 869.462, poster_path: "/63xYQj1BwRFielxsBDXvHIJyXVm.jpg", release_date: "2024-10-09", title: "Terrifier 3", video: false, vote_average: 6.863, vote_count: 1183)
