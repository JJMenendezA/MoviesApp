//
//  FilterMoviesByDate.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol FilterMoviesUseCase {
    func filter(moviesDictionary: [String: MoviesEntity],
                filterParameters: FilterParameters,
                releaseDateArray: [Date]) -> [String: MoviesEntity]
}

class FilterMoviesUseCaseImpl: FilterMoviesUseCase {
    func filter(moviesDictionary: [String: MoviesEntity],
                filterParameters: FilterParameters,
                releaseDateArray: [Date]) -> [String: MoviesEntity] {
        var mutableMoviesDictionary: [String: MoviesEntity] = moviesDictionary
        
        if filterParameters.language != filterParameters.defaultLanguage {
            mutableMoviesDictionary.forEach({ movie in
                mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                    movie.originalLanguage == filterParameters.language
                })
            })
        }
        
        if let firstDate = releaseDateArray.first,
           let lastDate = releaseDateArray.last {
            if filterParameters.startDate != firstDate ||
                filterParameters.endDate != lastDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                mutableMoviesDictionary.forEach({ movie in
                    mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                        dateFormatter.date(from: movie.releaseDate) ?? Date() >= filterParameters.startDate &&
                        dateFormatter.date(from: movie.releaseDate) ?? Date() <= filterParameters.endDate
                    })
                })
            }
        }
        
        return mutableMoviesDictionary
    }
}
