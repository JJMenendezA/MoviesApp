//
//  MovieDetailsInfo.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 17/03/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MovieDetailsEntity: Decodable {
    let title: String
    let moviePoster: String?
    let tagline: String
    let releaseDate: String
    let stars: Int
    let hasHalfStar: Bool
    let originalLanguage: String
    let genreList: String
    let runtime: Int
    let overview: String
    let similarMoviesList: [Movie]
    let movieVideo: URL?
    
    public init(from movie: MovieDetailsResponse) {
        self.title = movie.title
        self.moviePoster = movie.poster_path
        self.tagline = movie.tagline
        self.releaseDate = movie.releaseDateFormatted
        self.stars = Int(movie.vote_average.rounded(.down))/2
        self.hasHalfStar = movie.vote_average.truncatingRemainder(dividingBy: 1) >= 0.5
        self.originalLanguage =  Locale.current.localizedString(forLanguageCode: movie.original_language) ?? movie.original_language
        self.genreList = movie.genres.map(\.name).joined(separator: ", ")
        self.runtime = movie.runtime
        self.overview = movie.overview
        self.similarMoviesList = movie.similar.results
        self.movieVideo = movie.videos.results.first?.key != nil ? movieVideoURL.appendingPathComponent(movie.videos.results.first!.key) : nil
    }
}
