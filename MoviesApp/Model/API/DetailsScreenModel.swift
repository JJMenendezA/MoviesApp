//
//  DetailsScreenModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 14/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

struct MovieDetails: Decodable, Hashable {
    let adult: Bool
    let backdrop_path: String?
    let belongs_to_collection: String
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdb_id: String
    let original_language: String
    let original_title: String
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
    
}


struct Genre: Decodable, Hashable {
    let id: Int
    let name: String
}

struct ProductionCompany: Decodable, Hashable {
    let id: Int
    let logo_path: String
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
    let id: Int
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
