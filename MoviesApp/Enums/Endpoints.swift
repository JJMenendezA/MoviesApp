//
//  Endpoints.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

let baseURL: URL = URL(string: "https://api.themoviedb.org/3")!

enum EndpointsMovies {
    static let nowPlaying: String = "/movie/now_playing"
    static let popular: String = "/movie/popular"
    static let topRated: String = "/movie/top_rated"
    static let upcoming: String = "/movie/upcoming"
}
