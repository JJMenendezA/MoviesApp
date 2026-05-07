//
//  MainComponentsHighlight.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI
import Kingfisher

struct MainComponentsHighlight: View {
    @EnvironmentObject var router: Router
    var movie: Movie
    var body: some View {
        if let moviePosterPath = movie.posterPath,
           let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
            KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                .resizable()
                .frame(height: 700)
                .overlay {
                    Color.black.opacity(0.8)
                }
                .overlay {
                    VStack {
                        Button(action: { router.navigateTo(.details(id: movie.id)) },
                               label: {
                            KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                                .resizable()
                                .frame(width: 250, height: 350)
                                .padding(.horizontal, 35)
                                .padding(.top, 45)
                        })
                        VStack {
                            Text("Random pick of the day 👍")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.caption)
                            
                            Text(movie.title)
                                .multilineTextAlignment(.center)
                                .frame(alignment: .center)
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } // :VStack
                        .padding()
                    } // :VStack
                }
        }
    }
}
