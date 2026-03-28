//
//  SearchMoviesByTitleUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol SearchMoviesByTitleUseCase {
    func search(moviesDictionary: [String: MoviesEntity], title: String) -> [String: MoviesEntity]
}

class SearchMoviesByTitleUseCaseImpl: SearchMoviesByTitleUseCase {
    func search(moviesDictionary: [String: MoviesEntity], title: String) -> [String: MoviesEntity] {
        var mutableMoviesDictionary: [String: MoviesEntity] = moviesDictionary
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                movie.title.localizedCaseInsensitiveContains(title)
            })
        })
        
        return mutableMoviesDictionary
    }
}
