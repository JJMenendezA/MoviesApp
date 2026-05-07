//
//  Movie.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 30/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol Movie {
    var id: Int { get }
    var posterPath: String? { get }
    var releaseDate: String { get }
    var title: String { get }
    var originalLanguage: String { get }
    var voteAverage: Double { get }
}

extension Movie {
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
    
    var stars: Int {
        Int(voteAverage.rounded(.down))/2
    }
    
    var hasHalfStar: Bool {
        voteAverage.truncatingRemainder(dividingBy: 1) >= 0.5
    }
    
    var originalLanguageComplete: String {
        Locale.current.localizedString(forLanguageCode: originalLanguage) ?? originalLanguage
    }
}
