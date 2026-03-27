//
//  MovieModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 18/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public struct MoviesResponse: Decodable, Hashable {
    let dates: Dates?
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

public struct Movie: Decodable, Hashable {
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let id: Int
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: CGFloat
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: CGFloat
    let vote_count: Int
}

struct Dates: Decodable, Hashable {
    let maximum: String
    let minimum: String
}
