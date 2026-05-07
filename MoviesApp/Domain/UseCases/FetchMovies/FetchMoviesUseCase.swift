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
        var mutableMoviesDictionary: [String: MoviesEntity] = rawData
        rawData.forEach({ movie in
            switch movie.key {
            case MovieTypes.nowPlaying.title:
                if let moviesArray = mutableMoviesDictionary[movie.key]?.moviesArray {
                    mutableMoviesDictionary[movie.key]?.moviesArray = moviesArray
                        .sorted(by: { $0.releaseDate < $1.releaseDate })
                }
            case MovieTypes.upcoming.title:
                if let moviesArray = mutableMoviesDictionary[movie.key]?.moviesArray {
                    mutableMoviesDictionary[movie.key]?.moviesArray = moviesArray
                        .filter({ $0.releaseDate > getTwoWeeksAgoDate()})
                        .sorted(by: { $0.releaseDate < $1.releaseDate })
                }
            case MovieTypes.topRated.title:
                if let moviesArray = mutableMoviesDictionary[movie.key]?.moviesArray {
                    mutableMoviesDictionary[movie.key]?.moviesArray = moviesArray
                        .sorted(by: { $0.voteAverage > $1.voteAverage })
                }
            default:
                break
            }
        })
        
        return mutableMoviesDictionary
    }
}
