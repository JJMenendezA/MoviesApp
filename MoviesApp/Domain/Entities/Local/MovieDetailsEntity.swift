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
    var alternativeImage: String?
    let tagline: String
    let releaseDate: String
    let stars: Int
    let hasHalfStar: Bool
    let language: String
    let genreList: String
    let runtime: Int
    let overview: String
    let similarMoviesList: [MovieEntity]
    let movieVideo: URL?
    let productionCompanies: [ProductionCompanyEntity]
    
    public init(from movie: MovieDetailsResponse) {
        self.title = movie.title
        self.moviePoster = movie.poster_path
        self.alternativeImage = movie.backdrop_path
        self.tagline = movie.tagline
        self.releaseDate = movie.releaseDateFormatted
        self.stars = Int(movie.vote_average.rounded(.down))/2
        self.hasHalfStar = movie.vote_average.truncatingRemainder(dividingBy: 1) >= 0.5
        self.language = Locale.current.localizedString(forLanguageCode: movie.original_language) ?? movie.original_language
        self.genreList = movie.genres.map(\.name).joined(separator: ", ")
        self.runtime = movie.runtime
        self.overview = movie.overview
        self.similarMoviesList = movie.similar.results.map({ movie in
            MovieEntity(from: movie)
        })
        self.productionCompanies = movie.production_companies.map({ productionCompany in
            ProductionCompanyEntity(name: productionCompany.name,
                                    logoPath: productionCompany.logo_path,
                                    country: productionCompany.origin_country)
        })
        if let firstResult = movie.videos.results.first,
           let movieVideoURL = URL(string: "https://youtube.com/embed/") {
            self.movieVideo = movieVideoURL.appendingPathComponent(firstResult.key)
        } else {
            movieVideo = nil
        }
    }
}

public struct ProductionCompanyEntity: Decodable, Hashable {
    let name: String
    let logoPath: String?
    let country: String
}
