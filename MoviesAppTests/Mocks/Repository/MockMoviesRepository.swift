//
//  MockMoviesRepository.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockMoviesRepository: MoviesRepository {
    private let moviesService: MoviesService
    var shouldFail: Bool = false
    init(moviesService: MoviesService = MockMoviesService()) {
        self.moviesService = moviesService
    }
    
    func fetchMovies() async throws -> [String: MoviesEntity] {
        if shouldFail {
            throw AppError.noData
        } else {
            return ["popular": MoviesEntity(movieEntities: [MovieEntity(id: dummyMovieResponse.id,
                                                                        posterPath: dummyMovieResponse.poster_path,
                                                                        releaseDate: dummyMovieResponse.release_date,
                                                                        title: dummyMovieResponse.title,
                                                                        originalLanguage: dummyMovieResponse.original_language,
                                                                        voteAverage: dummyMovieResponse.vote_average)])]
        }
    }
    
    func fetchDetails(endPoint: String) async throws -> MovieDetailsEntity {
        if shouldFail {
            throw AppError.noData
        } else {
            let genreList = dummyDetailsMovieInfo.genres.map(\.name).joined(separator: ", ")
            let similarMoviesArray = dummyDetailsMovieInfo.similar.results.map({ movie in
                MovieEntity(id: movie.id,
                            posterPath: movie.poster_path,
                            releaseDate: movie.release_date,
                            title: movie.title,
                            originalLanguage: movie.original_language,
                            voteAverage: movie.vote_average)
            })
            let productionCompaniesArray = dummyDetailsMovieInfo.production_companies.map({ productionCompany in
                ProductionCompanyEntity(name: productionCompany.name,
                                        logoPath: productionCompany.logo_path,
                                        country: productionCompany.origin_country)
            })
            
            return MovieDetailsEntity(id: dummyDetailsMovieInfo.id,
                                      title: dummyDetailsMovieInfo.title,
                                      posterPath: dummyDetailsMovieInfo.poster_path,
                                      alternativeImage: dummyDetailsMovieInfo.backdrop_path,
                                      tagline: dummyDetailsMovieInfo.tagline,
                                      releaseDate: dummyDetailsMovieInfo.release_date,
                                      voteAverage: dummyDetailsMovieInfo.vote_average,
                                      originalLanguage: dummyDetailsMovieInfo.original_language,
                                      genreList: genreList,
                                      runTime: dummyDetailsMovieInfo.runtime,
                                      overview: dummyDetailsMovieInfo.overview,
                                      similarMoviesList: similarMoviesArray,
                                      productionCompanies: productionCompaniesArray)
        }
    }
}
