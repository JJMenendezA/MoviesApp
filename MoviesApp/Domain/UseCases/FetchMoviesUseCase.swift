//
//  FetchMoviesUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 25/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

protocol FetchMoviesUseCase {
    func fetch() async throws -> [String: MoviesEntity]
}

class FetchMoviesUseCaseImpl: FetchMoviesUseCase {
    private let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func fetch() async throws -> [String: MoviesEntity] {
        let rawData = try await repository.fetchMovies()
        var mutableMoviesDictionary: [String: MoviesEntity] = [:]
        rawData.forEach({ movie in
            switch movie.key {
            case MovieTypes.popular.title, MovieTypes.topRated.title:
                mutableMoviesDictionary[movie.key] = MoviesEntity(movies: movie.value.results)
            case MovieTypes.nowPlaying.title:
                mutableMoviesDictionary[movie.key] = MoviesEntity(movies: movie.value.results
                    .sorted(by: { $0.release_date < $1.release_date }))
            case MovieTypes.upcoming.title:
                mutableMoviesDictionary[movie.key] = MoviesEntity(movies: movie.value.results
                    .filter({ $0.release_date > getTwoWeeksAgoDate()})
                    .sorted(by: { $0.release_date < $1.release_date }))
                
            default:
                break
            }
        })
        
        return mutableMoviesDictionary
    }
}
