//
//  MainComponentsMoviesLists.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 06/05/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MainComponentsMoviesLists: View {
    var mutableMoviesDictionary: [String: MoviesEntity]
    var body: some View {
        // MARK: - TOP RATED MOVIES SECTION
        if let topRatedList = mutableMoviesDictionary[MovieTypes.topRated.title] {
            if !topRatedList.moviesArray.isEmpty {
                MainComponentsList(title: "Top rated",
                                   movies: topRatedList.moviesArray)
            }
        }
        
        // MARK: - NOW PLAYING MOVIES SECTION
        if let nowPlayingList = mutableMoviesDictionary[MovieTypes.nowPlaying.title] {
            if !nowPlayingList.moviesArray.isEmpty {
                MainComponentsList(title: "Now playing",
                                   movies: nowPlayingList.moviesArray)
            }
        }
        
        // MARK: - POPULAR MOVIES SECTION
        if let popularList = mutableMoviesDictionary[MovieTypes.popular.title] {
            if !popularList.moviesArray.isEmpty {
                MainComponentsList(title: "Popular",
                                   movies: popularList.moviesArray)
            }
        }
        
        // MARK: - UPCOMING MOVIES SECTION
        if let upcomingList = mutableMoviesDictionary[MovieTypes.upcoming.title] {
            if !upcomingList.moviesArray.isEmpty {
                MainComponentsList(title: "Upcoming",
                                   movies: upcomingList.moviesArray,
                                   isUpcoming: true)
            }
        }
    }
}

#Preview {
    MainComponentsMoviesLists(mutableMoviesDictionary: [:])
}
