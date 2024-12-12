//
//  MovieItem.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 27/10/24.
//

import SwiftUI
import Kingfisher

struct MovieItemComponent: View {
    var movie: MovieInfo
    var isUpcoming: Bool = false
    var body: some View {
        // MARK: - Movie Item
        NavigationLink(destination: DetailsScreenView(movie: movie)){
            ZStack {
                if let moviePosterPath = movie.poster_path {
                    KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            // Gradient for the image
                            RoundedRectangle(cornerRadius: 10)
                                .fill(LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .bottom, endPoint: .top))
                        }
                }
                
                
                VStack {
                    Spacer()
                    Text(movie.title)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.body)
                        .frame(height: 40)
                        .padding(.horizontal, 5)
                    
                    HStack {
                        ForEach (0..<movie.stars, id: \.self) { index in
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                        }
                        
                        if movie.hasHalfStar {
                            Image(systemName: "star.leadinghalf.filled")
                                .resizable()
                                .frame(width: 10, height: 10)
                        }
                    } // :HStack
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.4)
                    .frame(width: 75, height: 10)
                    .font(Font.system(size: 15))
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
                } // :VStack
                
                if isUpcoming {
                    Text(movie.releaseDateFormatted)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)
                        .frame(width: 75, height: 10)
                        .font(Font.system(size: 20))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(customLinearGradient(colors: [.purple700, .purple900]))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 85)
                }
                
            } // :ZStack
            .frame(width: 115, height: 165)
            .simultaneousGesture(
                TapGesture().onEnded {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                }
            )
        } // :NavigationLink
    }
    
}

#Preview {
    MovieItemComponent(movie: dummyMovieInfo)
}
