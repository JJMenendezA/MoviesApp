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
    let stars: Int
    let hasHalfStar: Bool
    
    public init (from movie: Movie) {
        self.id = movie.id
        self.posterPath = movie.poster_path
        self.releaseDate = movie.releaseDateFormatted
        self.title = movie.title
        self.stars = Int(movie.vote_average.rounded(.down))/2
        self.hasHalfStar =  movie.vote_average.truncatingRemainder(dividingBy: 1) >= 0.5
    }
}
