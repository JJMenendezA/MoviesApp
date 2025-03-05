//
//  MoviesListComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 01/11/24.
//

import SwiftUI

struct MoviesListComponent: View {
    var movies: [MovieInfo]
    var isUpcoming: Bool = false
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(movies, id: \.id){ movie in
                    MovieItemComponent(movie: movie, isUpcoming: isUpcoming)
                }
            } // :HStack
            .padding(.bottom, 20)
        } // :ScrollView
        .scrollDisabled(movies.count == 1 ? true : false)
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

#Preview {
    MoviesListComponent(movies: [dummyMovieInfo, dummyMovieInfo])
}
