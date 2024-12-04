//
//  MovieModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 18/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct Movies: Decodable, Hashable {
    let dates: Dates?
    let page: Int
    let results: [MovieInfo]
    let total_pages: Int
    let total_results: Int
    
    // Computed Properties
    var originalLanguagesSet: Set<String> {
        Set(results.map({
            Locale.current.localizedString(forLanguageCode: $0.original_language) ?? $0.original_language
        })
        )
    }
    
    var releaseDatesSet: Set<Date> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return Set(results.map({
            dateFormatter.date(from: $0.release_date)!
        })
        )
    }
}

struct MovieInfo: Decodable, Hashable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: CGFloat
    let poster_path: String
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: CGFloat
    let vote_count: Int
    
    // Computed Properties
    var stars: Int {
        Int(vote_average.rounded(.down))/2
    }
    
    var hasHalfStar: Bool {
        vote_average.truncatingRemainder(dividingBy: 1) >= 0.5
    }
}

struct Dates: Decodable, Hashable {
    let maximum: String
    let minimum: String
}
