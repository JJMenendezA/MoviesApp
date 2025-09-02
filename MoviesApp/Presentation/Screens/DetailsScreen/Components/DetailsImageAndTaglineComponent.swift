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
    var moviePoster: String?
    var tagline: String
    var body: some View {
        if let moviePosterPath = moviePoster,
            let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
            KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                .resizable()
                .frame(width: 300, height: 425)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 10)
                .padding(.bottom, 20)
        }
        
        Text(tagline)
            .italic()
            .fontWeight(.heavy)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, tagline.isEmpty ? 0 : 20)
            .lineLimit(4)
            .minimumScaleFactor(0.5)
        
    }
}

#Preview {
    DetailsImageAndTaglineComponent(moviePoster: "", tagline: "Example")
}
