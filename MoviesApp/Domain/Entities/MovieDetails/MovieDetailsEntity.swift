//
//  MovieDetailsInfo.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 17/03/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MovieDetailsEntity: Movie {
    let id: Int
    let title: String
    let posterPath: String?
    var alternativeImage: String?
    let tagline: String
    let releaseDate: String
    let voteAverage: Double
    let originalLanguage: String
    let genreList: String
    let runtime: Int
    let overview: String
    let similarMoviesList: [MovieEntity]
    let productionCompanies: [ProductionCompanyEntity]
    
    public init(id: Int,
                title: String,
                posterPath: String?,
                alternativeImage: String?,
                tagline: String,
                releaseDate: String,
                voteAverage: Double,
                originalLanguage: String,
                genreList: String,
                runTime: Int,
                overview: String,
                similarMoviesList: [MovieEntity],
                productionCompanies: [ProductionCompanyEntity]) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.alternativeImage = alternativeImage
        self.tagline = tagline
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.originalLanguage = originalLanguage
        self.genreList = genreList
        self.runtime = runTime
        self.overview = overview
        self.similarMoviesList = similarMoviesList
        self.productionCompanies = productionCompanies
    }
}

public struct ProductionCompanyEntity: Hashable {
    let name: String
    let logoPath: String?
    let country: String
}
