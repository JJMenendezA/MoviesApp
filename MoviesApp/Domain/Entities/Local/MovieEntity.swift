//
//  MovieEntity.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 23/03/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MoviesEntity {
    var moviesArray: [MovieEntity]
    
    public init(movieEntities: [MovieEntity]) {
        self.moviesArray = movieEntities
    }
    
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
    
    public init(id: Int,
                posterPath: String?,
                releaseDate: String,
                title: String,
                originalLanguage: String,
                voteAverage: Double) {
        self.id = id
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.originalLanguage = originalLanguage
        self.voteAverage = voteAverage
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
