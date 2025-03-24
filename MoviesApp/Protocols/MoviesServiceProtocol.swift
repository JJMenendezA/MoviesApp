//
//  NetworkServiceProtocol.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public protocol MoviesServiceProtocol {
    func fetchAllMovies(completion: @escaping (Result<[String: MoviesResponse], AppError>) -> Void)
    func fetchMovies(endpoint: String, completion: @escaping (Result<MoviesResponse, AppError>) -> Void)
    func fetchMovieDetails(endPoint: String, completion: @escaping (Result<MovieDetailsResponse, AppError>) -> Void)
}
