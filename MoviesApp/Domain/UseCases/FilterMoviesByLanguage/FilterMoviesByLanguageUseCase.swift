//
//  FilterMoviesByLanguageUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol FilterMoviesByLanguageUseCase {
    func filter(moviesDictionary: [String: MoviesEntity], language: String) -> [String: MoviesEntity]
}

class FilterMoviesByLanguageUseCaseImpl: FilterMoviesByLanguageUseCase {
    func filter(moviesDictionary: [String: MoviesEntity], language: String) -> [String: MoviesEntity] {
        var mutableMoviesDictionary: [String: MoviesEntity] = moviesDictionary
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                movie.originalLanguage == language
            })
        })
        return mutableMoviesDictionary
    }
}
