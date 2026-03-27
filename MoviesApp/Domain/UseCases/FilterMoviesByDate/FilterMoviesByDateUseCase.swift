//
//  FilterMoviesByDate.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol FilterMoviesByDateUseCase {
    func filter(moviesDictionary: [String: MoviesEntity], startDate: Date, endDate: Date) -> [String: MoviesEntity]
}

class FilterMoviesByDateUseCaseImpl: FilterMoviesByDateUseCase {
    func filter(moviesDictionary: [String: MoviesEntity], startDate: Date, endDate: Date) -> [String: MoviesEntity] {
        var mutableMoviesDictionary: [String: MoviesEntity] = moviesDictionary
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                dateFormatter.date(from: movie.releaseDate) ?? Date() >= startDate &&
                dateFormatter.date(from: movie.releaseDate) ?? Date() <= endDate
            })
        })
        
        return mutableMoviesDictionary
    }
}
