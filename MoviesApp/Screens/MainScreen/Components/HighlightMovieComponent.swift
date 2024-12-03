//
//  HighlightMovieComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI
import Kingfisher

struct HighlightMovieComponent: View {
    var movie: MovieInfo
    var body: some View {
        ZStack {
            KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                .resizable()
                .frame(height: 700)
                .overlay{
                    Color.black.opacity(0.6)
                }
            
            VStack {
                KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                    .resizable()
                    .frame(width: 250, height: 350)
                    .padding(.horizontal, 35)
                    .padding(.top, 45)
                
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
        } // :ZStack
    }
}

#Preview {
    HighlightMovieComponent(movie: dummyMovieInfo)
}
