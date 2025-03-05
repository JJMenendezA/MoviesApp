//
//  DetailsScreenModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 14/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MovieDetails: Decodable, Hashable {
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: MovieCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdb_id: String?
    let original_language: String
    let original_title: String
    let origin_country: [String]
    let overview: String
    let popularity: CGFloat
    let poster_path: String?
    let production_companies: [ProductionCompany]
    let production_countries: [ProductionCountry]
    let release_date: String
    let revenue: Int
    let runtime: Int
    let spoken_languages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let vote_average: CGFloat
    let vote_count: Int
    let videos: Videos
    let similar: Movies
    
    // Computed Properties
    var stars: Int {
        Int(vote_average.rounded(.down))/2
    }
    
    var hasHalfStar: Bool {
        vote_average.truncatingRemainder(dividingBy: 1) >= 0.5
    }
    
    var releaseDateFormatted: String {
        if release_date == "" {
            return release_date
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateFormatted = dateFormatter.date(from: release_date)
            
            let outputDate = DateFormatter()
            outputDate.dateFormat = "dd MMM yyyy"
            
            return outputDate.string(from: dateFormatted!)
        }
    }
    
    var originalLanguageComplete: String {
        Locale.current.localizedString(forLanguageCode: original_language) ?? original_language
    }
    
    var genresList: String {
        genres.map(\.name).joined(separator: ", ")
    }
}

struct Genre: Decodable, Hashable, Identifiable {
    let id: Int
    let name: String
}

struct MovieCollection: Decodable, Hashable {
    let id: Int
    let name: String
    let poster_path: String
    let backdrop_path: String
    
}

struct ProductionCompany: Decodable, Hashable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}

struct ProductionCountry: Decodable, Hashable {
    let iso_3166_1: String
    let name: String
}

struct SpokenLanguage: Decodable, Hashable {
    let english_name: String
    let iso_639_1: String
    let name: String
}

struct Videos: Decodable, Hashable {
    let id: Int?
    let results: [ResultVideo]
}

struct ResultVideo: Decodable, Hashable {
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let published_at: String
    let id: String
}
