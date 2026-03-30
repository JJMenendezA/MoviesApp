//
//  MoviePaths.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 30/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

enum MoviePaths {
    case details(movieId: Int)

    var endpoint: String {
        switch self {
        case .details(movieId: let movieId): return "movie/\(movieId)"
        }
    }
}
