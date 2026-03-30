//
//  FetchMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//
import Foundation

protocol FetchMovieDetailsUseCase {
    func fetch(endPoint: String) async throws -> MovieDetailsEntity
}

class FetchMovieDetailsImpl: FetchMovieDetailsUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func fetch(endPoint: String) async throws -> MovieDetailsEntity {
        let rawData = try await repository.fetchDetails(endPoint: endPoint)

        let genreList = rawData.genres.map(\.name).joined(separator: ", ")
        let similarMoviesArray = rawData.similar.results.map({ movie in
            MovieEntity(id: movie.id,
                        posterPath: movie.poster_path,
                        releaseDate: movie.release_date,
                        title: movie.title,
                        originalLanguage: movie.original_language,
                        voteAverage: movie.vote_average)
        })
        let productionCompaniesArray = rawData.production_companies.map({ productionCompany in
            ProductionCompanyEntity(name: productionCompany.name,
                                    logoPath: productionCompany.logo_path,
                                    country: productionCompany.origin_country)
        })
        
        return MovieDetailsEntity(id: rawData.id,
                                  title: rawData.title,
                                  posterPath: rawData.poster_path,
                                  alternativeImage: rawData.backdrop_path,
                                  tagline: rawData.tagline,
                                  releaseDate: rawData.release_date,
                                  voteAverage: rawData.vote_average,
                                  originalLanguage: rawData.original_language,
                                  genreList: genreList,
                                  runTime: rawData.runtime,
                                  overview: rawData.overview,
                                  similarMoviesList: similarMoviesArray,
                                  productionCompanies: productionCompaniesArray)
    }
}
