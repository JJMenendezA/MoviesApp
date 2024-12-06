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
        VStack {
            KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                .resizable()
                .frame(width: 300, height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 10)
            
            Text(movie.title)
                .foregroundStyle(.white)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                    
                }
            
            HStack {
                Text("Release Date:")
                    .foregroundStyle(.white)
                SubtitleComponent(text: movie.release_date)

            } // :HStack
            .padding()
           
            
            Spacer()
            
        } // :VStack
        .frame(maxWidth: .infinity)
        .background(.gray900)
    }
}

#Preview {
    DetailsScreenView()
}
