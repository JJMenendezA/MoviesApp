//
//  NetworkServiceProtocol.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public protocol MoviesServiceProtocol {
    func fetchAllMovies() async throws -> [String: MoviesResponse]
    func fetchMovies(endpoint: String) async throws -> MoviesResponse
    func fecthMovieDetails(endPoint: String) async throws -> MovieDetailsResponse
}
