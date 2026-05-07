//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 30/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol MoviesRepository {
    func fetchMovies() async throws -> [String: MoviesEntity]
    func fetchDetails(endPoint: String) async throws -> MovieDetailsEntity
}
