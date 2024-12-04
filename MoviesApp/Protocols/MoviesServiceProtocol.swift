//
//  NetworkServiceProtocol.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public protocol MoviesServiceProtocol {
    func fetchAllMovies(completion: @escaping (Result<[String : Movies], AppError>) -> Void)
    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, AppError>) -> Void)
}
