//
//  MockFetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockFetchMoviesUseCase: FetchMoviesUseCase {
    var shouldFail: Bool = false
    
    func fetch() async throws -> [String: MoviesEntity] {
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
}
