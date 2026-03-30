//
//  MoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol MoviesRepository {
    func fetchMovies() async throws -> [String: MoviesEntity]
    func fetchDetails(endPoint: String) async throws -> MovieDetailsEntity
}

class MoviesRepositoryImpl: MoviesRepository {
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    func fetchMovies() async throws -> [String: MoviesEntity] {
        let rawData = try await moviesService.fetchAllMovies()
        var mutableMoviesDictionary: [String: MoviesEntity] = [:]
        rawData.forEach({ movie in
            mutableMoviesDictionary[movie.key] = MoviesEntity(movieEntities: movie.value.results.map({ movie in
                MovieEntity(id: movie.id,
                            posterPath: movie.poster_path,
                            releaseDate: movie.release_date,
                            title: movie.title,
                            originalLanguage: movie.original_language,
                            voteAverage: movie.vote_average)
            }))
        })
        
        return mutableMoviesDictionary
    }
    
    func fetchDetails(endPoint: String) async throws -> MovieDetailsEntity {
        let rawData = try await moviesService.fetchMovieDetails(endPoint: endPoint)

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
