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
    @Environment(\.dismiss) var dismiss
    var movie: MovieInfo
    var body: some View {
        VStack {
            
            HStack(spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                }
              
                Spacer()
                
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Spacer()
            } // :HStack
            .padding(.horizontal)
            
            Divider()
                .frame(height: 0.5)
                .overlay(.white)
                .padding(.horizontal)
            
            ScrollView {
                VStack {
                    KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                        .resizable()
                        .frame(width: 300, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 10)

                    Divider()
                        .frame(height: 0.5)
                        .overlay(.white)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Release date:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(7)
                                .background(customLinearGradient(colors: [.gray900, .purple900]))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text(movie.releaseDateFormatted)
                                .font(.body)
                                .foregroundStyle(.white)
                        } // :VStack
                        
                        Spacer()
                        
                        Divider()
                            .frame(width: 1)
                            .overlay(.white)
                        
                        Spacer()
                        
                        VStack {
                            Text("Original language:")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(7)
                                .background(customLinearGradient(colors: [.gray900, .purple900]))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text(movie.originalLanguageComplete)
                                .font(.body)
                                .foregroundStyle(.white)
                        } // :VStack
                        
                        Spacer()
                    } // :HStack
                    
                    Divider()
                        .frame(height: 0.5)
                        .overlay(.white)
                        .padding(.horizontal)
                    
                    Text("Overview:")
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.title2)
                        .padding(7)
                        .background(customLinearGradient(colors: [.gray900, .purple900]))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                    Text(movie.overview)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .frame(height: 0.5)
                        .overlay(.white)
                        .padding(.horizontal)
                    
                    Text("Vote average:")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(7)
                        .background(customLinearGradient(colors: [.gray900, .purple900]))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
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
                    
                    
                    
                    Spacer()
                    
                } // :VStack
                
            } // :ScrollView
        } // :VStack
        .frame(maxWidth: .infinity)
        .background(.gray900)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DetailsScreenView(movie: dummyMovieInfo)
}
