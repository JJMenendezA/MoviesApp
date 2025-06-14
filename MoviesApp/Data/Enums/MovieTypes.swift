//
//  MovieTypes.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 01/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

enum MovieTypes: CaseIterable {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    var title: String {
        switch self {
        case .nowPlaying: return "NowPlaying"
        case .popular: return "Popular"
        case .topRated: return "TopRated"
        case .upcoming: return "Upcoming"
        }
    }
    
    var endpoint: String {
        switch self {
        case .nowPlaying: return "movie/now_playing"
        case .popular: return "movie/popular"
        case .topRated: return "movie/top_rated"
        case .upcoming: return "movie/upcoming"
        }
    }
}

enum MoviePathTypes {
    case details(movieId: Int)

    var endpoint: String {
        switch self {
        case .details(movieId: let movieId): return "movie/\(movieId)"
        }
    }
}
