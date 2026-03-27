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
                mutableMoviesDictionary[movie.key] = MoviesEntity(movieEntities: movie.value.results.map({ MovieEntity(from: $0) }))
            case MovieTypes.nowPlaying.title:
                mutableMoviesDictionary[movie.key] = MoviesEntity(movieEntities: movie.value.results.map({ MovieEntity(from: $0) })
                    .sorted(by: { $0.releaseDate < $1.releaseDate }))
            case MovieTypes.upcoming.title:
                mutableMoviesDictionary[movie.key] = MoviesEntity(movieEntities: movie.value.results.map({ MovieEntity(from: $0) })
                    .filter({ $0.releaseDate > getTwoWeeksAgoDate()})
                    .sorted(by: { $0.releaseDate < $1.releaseDate }))
                
            default:
                break
            }
        })
        
        return mutableMoviesDictionary
    }
}
