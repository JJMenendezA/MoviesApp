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
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                
                Spacer()
            } // :HStack
            .padding(.horizontal)
            
            ScrollView {
                VStack {
                    KFImage(movieImageURL.appendingPathComponent(movie.poster_path))
                        .resizable()
                        .frame(width: 300, height: 425)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 10)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Text("Release date")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.purple900, .purple500]).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .multilineTextAlignment(.center)
                            
                            Text(movie.releaseDateFormatted)
                                .font(.body)
                                .foregroundStyle(.white)
                        } // :VStack
                        
                        Spacer()
                        
                        VStack {
                            Text("Vote average")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.purple900, .purple500]).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
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
                            .padding(.horizontal, 10)
                        } // :VStack
                        
                        Spacer()
                    } // :HStack
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Original language")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.5)
                                .padding(10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.purple900, .purple500]).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            
                            Text(movie.originalLanguageComplete)
                                .font(.body)
                                .foregroundStyle(.white)
                        } // :VStack
                        
                        Spacer()
                        
                        VStack {
                            Text("Original title")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 5)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.purple900, .purple500]).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text(movie.original_title)
                                .font(.body)
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                                .frame(maxWidth: 150, maxHeight: 40)
                        } // :VStack
                        Spacer()
                    } // :HStack
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    Text("Overview")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 5)
                        .foregroundStyle(.white)
                        .padding(10)
                        .frame(maxWidth: 150, maxHeight: 40)
                        .multilineTextAlignment(.center)
                        .background(customLinearGradient(colors: [.purple900, .purple500]).opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(movie.overview)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
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
