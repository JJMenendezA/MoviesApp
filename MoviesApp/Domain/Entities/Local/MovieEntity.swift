//
//  MovieEntity.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 23/03/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MoviesEntity {
    init(movieEntities: [MovieEntity]) {
        self.moviesArray = movieEntities
    }
    var moviesArray: [MovieEntity]
    
    // Computed properties
    var originalLanguagesSet: Set<String> {
        Set(moviesArray.map({ $0.originalLanguage }))
    }
    
    var releaseDatesSet: Set<Date> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return Set(moviesArray.map({
            dateFormatter.date(from: $0.releaseDate) ?? Date()
        }))
    }
}

public struct MovieEntity {
    let id: Int
    let posterPath: String?
    let releaseDate: String
    let title: String
    let originalLanguage: String
    let voteAverage: Double
    
    public init (from movie: Movie) {
        self.id = movie.id
        self.posterPath = movie.poster_path
        self.releaseDate = movie.release_date
        self.title = movie.title
        self.originalLanguage = movie.original_language
        self.voteAverage = movie.vote_average
    }
    
    public init (from movie: MovieDetailsResponse) {
        self.id = movie.id
        self.posterPath = movie.poster_path
        self.releaseDate = movie.releaseDateFormatted
        self.title = movie.title
        self.originalLanguage = movie.original_language
        self.voteAverage = movie.vote_average
    }
    
    // Computed properties
    var stars: Int {
        Int(voteAverage.rounded(.down))/2
    }
    
    var hasHalfStar: Bool {
        voteAverage.truncatingRemainder(dividingBy: 1) >= 0.5
    }
    
    var releaseDateFormatted: String {
        if releaseDate.isEmpty {
            return releaseDate
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateFormatted = dateFormatter.date(from: releaseDate)
            
            let outputDate = DateFormatter()
            outputDate.dateFormat = "dd MMM yyyy"
            
            return outputDate.string(from: dateFormatted ?? Date())
        }
    }
    
    var originalLanguageComplete: String {
        Locale.current.localizedString(forLanguageCode: originalLanguage) ?? originalLanguage
    }
}
