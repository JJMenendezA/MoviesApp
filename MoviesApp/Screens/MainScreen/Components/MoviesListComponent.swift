//
//  MoviesListComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 01/11/24.
//

import SwiftUI

struct MoviesListComponent: View {
    var title: String = "Movies"
    var movies: [MovieInfo]
    var isUpcoming: Bool = false
    var isPremiereSection: Bool = false
    var body: some View {
        SubtitleComponent(text: title)
        ScrollView(.horizontal) {
            HStack(spacing: 15) {
                ForEach(movies, id: \.id){ movie in
                    MovieItemComponent(movie: movie, isUpcoming: isUpcoming, isTopRated: isPremiereSection)
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
    MoviesListComponent(movies: [dummyMovieInfo])
}
