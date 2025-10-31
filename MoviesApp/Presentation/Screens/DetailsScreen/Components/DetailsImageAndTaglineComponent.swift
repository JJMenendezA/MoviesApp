//
//  DetailsImageAndTaglineComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailsImageAndTaglineComponent: View {
    var moviePosters: [String?]
    var tagline: String
    @State var xScale: CGFloat = 1
    @State var multiMoviePoster: String = ""
    var body: some View {
        VStack {
            if moviePosters.count > 1 {
                if let moviePosterPath = moviePosters[0],
                   let alternativeImagePath = moviePosters[1],
                   let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
                    Button(action: {
                        withAnimation {
                            if xScale < 0 {
                                xScale = 1
                                multiMoviePoster = moviePosterPath
                            } else {
                                xScale = -1
                                multiMoviePoster = alternativeImagePath
                            }
                        }
                    }, label: {
                        KFImage(movieImageURL.appendingPathComponent(multiMoviePoster))
                            .resizable()
                            .frame(width: 300, height: 425)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                            .scaleEffect(x: xScale, y: 1)
                    })
                }
            } else {
                if let moviePosterPath = moviePosters[0],
                   let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
                    KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                        .resizable()
                        .frame(width: 300, height: 425)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 10)
                        .padding(.bottom, 20)
                }
            }
            
            Text(tagline)
                .italic()
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, tagline.isEmpty ? 0 : 20)
                .lineLimit(4)
                .minimumScaleFactor(0.5)
        } // :VStack
        .onAppear {
            if !moviePosters.isEmpty {
                if let moviePosterPath = moviePosters[0] {
                    multiMoviePoster = moviePosterPath
                }
            }
        }
    }
}

#Preview {
    DetailsImageAndTaglineComponent(moviePosters: ["/63xYQj1BwRFielxsBDXvHIJyXVm.jpg", "/18TSJF1WLA4CkymvVUcKDBwUJ9F.jpg"], tagline: "Example")
}
