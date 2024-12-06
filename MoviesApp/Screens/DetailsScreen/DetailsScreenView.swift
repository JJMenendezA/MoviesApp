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
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.leading)
                
                HStack {
                    Spacer()
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
            }
            .padding(.bottom)
            .background(.black)
            .shadow(color: .black, radius: 10)
            
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
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
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
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
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
                    .padding(.bottom, 20)
                    
                    
                    
                    HStack {
                        Spacer()
                        
                        VStack {
                            Text("Original language")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.5)
                                .padding(.vertical, 10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
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
                                .foregroundStyle(.white)
                                .padding(.vertical, 10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
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
                    .padding(.bottom, 20)
                    
                    Text("Overview")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(10)
                        .frame(maxWidth: 150, maxHeight: 40)
                        .multilineTextAlignment(.center)
                        .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(movie.overview)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    
                    Spacer()
                    
                } // :VStack
                .padding(.horizontal, 30)
                .padding(.vertical)
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
