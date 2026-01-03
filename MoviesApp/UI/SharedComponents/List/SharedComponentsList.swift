//
//  SharedComponentsList.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 01/11/24.
//

import SwiftUI

struct SharedComponentsList: View {
    var movies: [MovieEntity]
    var isUpcoming: Bool = false
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 15) {
                ForEach(movies, id: \.id) { movie in
                    SharedComponentsListItem(movie: movie, isUpcoming: isUpcoming)
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
    SharedComponentsList(movies: [dummyMovieEntity, dummyMovieEntity])
}
