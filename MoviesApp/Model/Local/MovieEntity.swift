//
//  MovieEntity.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 23/03/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MovieEntity: Decodable {
    let id: Int
    let posterPath: String?
    let releaseDate: String
    let title: String
    let originalLanguage: String
    let voteAverage: Double
    
    public init (from movie: Movie) {
        self.id = movie.id
        self.posterPath = movie.poster_path
        self.releaseDate = movie.releaseDateFormatted
        self.title = movie.title
        self.originalLanguage = movie.original_language
        self.voteAverage = movie.vote_average
    }
    
    // Computed properties
    var stars: Int {
        Int(voteAverage.rounded(.down))/2
    }
    
    var hasHalfStar: Bool {
        voteAverage.truncatingRemainder(dividingBy: 1) >= 0.5
    }
}
