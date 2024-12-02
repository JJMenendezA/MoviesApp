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
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)"))
                .resizable()
                .frame(height: 700)
                .overlay{
                    Color.black.opacity(0.6)
                }
            
            VStack {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500" + movie.poster_path))
                    .resizable()
                    .frame(width: 200, height: 300)
                    .padding(.horizontal, 35)
                    .padding(.top, 45)
                
                VStack {
                    Text("Random pick of the day 👍")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.caption)
                    
                    Text(movie.title)
                        .frame(alignment: .center)
                        .foregroundStyle(.white)
                        .font(.title)
                        .fontWeight(.bold)
                } // :VStack
                .padding()
                
                // MARK: - BUTTON SECTION
                HStack {
                    ButtonComponent(text: "See more info", colorGradient: customLinearGradient(colors: [.pink700, .pink900]), shape: .capsule, fontWeight: .light, font: .callout){
                        
                    }
                    .padding()
                    
                    ButtonComponent(text: "Watch trailer", colorGradient: customLinearGradient(colors: [.clear]), shape: .capsule, fontWeight: .light, font: .callout){
                        // TODO Button action
                    } // :Button
                    .overlay{
                        Capsule()
                            .stroke(.white)
                    } // :Overlay
                    .padding()
                    
                } // :HStack
                .padding(.top)
            } // :VStack
        } // :ZStack
    }
}

#Preview {
    HighlightMovieComponent(movie: dummyMovieInfo)
}
