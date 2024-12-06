//
//  DetailsScreenView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 05/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailsScreenView: View {
    var movie: MovieInfo = dummyMovieInfo
    var body: some View {
        ScrollView {
            VStack {
                KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                    .resizable()
                    .frame(width: 300, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 10)
                
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                HStack {
                    VStack {
                        Text("Release Date:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text(movie.releaseDateFormatted)
                            .font(.body)
                            .foregroundStyle(.white)
                    } // :VStack
                    
                    Spacer()
                    
                    VStack {
                        Text("Original language:")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text(movie.originalLanguageComplete)
                            .font(.body)
                            .foregroundStyle(.white)
                    } // :VStack
                } // :HStack
                .padding()
                
                Text("Vote average:")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack {
                    ForEach (0..<movie.stars, id: \.self) { index in
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    if movie.hasHalfStar {
                        Image(systemName: "star.leadinghalf.filled")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                } // :HStack
                .foregroundStyle(.white)
                .padding(.bottom, 10)
                .padding(.horizontal, 10)
                
                
                Text("Overview:")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                
                Text(movie.overview)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                
                Spacer()
                
            } // :VStack
            
        } // :ScrollView
        .frame(maxWidth: .infinity)
        .background(.gray900)
    }
}

#Preview {
    DetailsScreenView()
}
