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
    @ObservedObject var detailsScreenViewModel: DetailsScreenViewModel = DetailsScreenViewModel()
    var movieId: Int
    var body: some View {
        ZStack {
            if detailsScreenViewModel.isLoading {
                LoaderComponent()
            } else {
                VStack(spacing: 0) {
                    // MARK: - HEADER SECTION
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
                            if let movie = detailsScreenViewModel.movieDetails {
                                Text(movie.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: 300)
                            }
                            
                            Spacer()
                        } // :HStack
                    } // :ZStack
                    .padding(.bottom)
                    .background(.black)
                    .shadow(color: .black, radius: 10)
                    
                    ScrollView {
                        VStack {
                            if  let movie = detailsScreenViewModel.movieDetails,
                                let moviePosterPath = movie.poster_path {
                                KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                                    .resizable()
                                    .frame(width: 300, height: 425)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .shadow(radius: 10)
                                    .padding(.bottom, 20)
                            }
                            
                            if let movie = detailsScreenViewModel.movieDetails {
                                Text("\(movie.tagline)")
                                    .italic()
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, movie.tagline.isEmpty ? 0 : 20)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                            }
                          
                            
                            
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
                                    
                                    if let movie = detailsScreenViewModel.movieDetails {
                                        Text(movie.releaseDateFormatted.isEmpty ? "No date available." : movie.releaseDateFormatted)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                    }
                                   
                                } // :VStack
                                .frame(width: 150)
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
                                    
                                    // MARK: - STAR SECTION
                                    HStack {
                                        if let movie = detailsScreenViewModel.movieDetails {
                                            if movie.stars > 0 {
                                                ForEach (0..<movie.stars, id: \.self) { index in
                                                    Image(systemName: "star.fill")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .frame(height: 50)
                                                }
                                                
                                                if movie.hasHalfStar {
                                                    Image(systemName: "star.leadinghalf.filled")
                                                        .resizable()
                                                        .frame(width: 20, height: 20)
                                                        .frame(height: 50)
                                                }
                                            } else {
                                                Text("No rating available.")
                                                    .font(.body)
                                                    .foregroundStyle(.white)
                                                    .frame(maxWidth: 150, maxHeight: 40)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .lineLimit(2)
                                                    .frame(height: 50)
                                            }
                                        }
                                    } // :HStack
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 10)
                                } // :VStack
                                .frame(width: 150)
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
                                    
                                    if let movie = detailsScreenViewModel.movieDetails {
                                        Text(movie.originalLanguageComplete)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                    }
                                } // :VStack
                                .frame(width: 150)
                                
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
                                    
                                    if let movie = detailsScreenViewModel.movieDetails {
                                        Text(movie.original_title)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .frame(height: 50)
                                    }
                                } // :VStack
                                .frame(width: 150)
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
                            
                            if let movie = detailsScreenViewModel.movieDetails {
                                Text(movie.overview)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 20)
                            }
                            
                            Text("Similar movies")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(10)
                                .frame(maxWidth: 150, maxHeight: 40)
                                .multilineTextAlignment(.center)
                                .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            MoviesListComponent(movies: detailsScreenViewModel.similarMoviesList)
                            
                            
                            Spacer()
                            
                        } // :VStack
                        .padding(.horizontal, 30)
                        .padding(.vertical)
                    } // :ScrollView
                } // :VStack
                .frame(maxWidth: .infinity)
                .background(.gray900)
            }
        } // :ZStack
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $detailsScreenViewModel.hasErrorTrigerred){
            Alert(title: Text("Error"), message: Text(detailsScreenViewModel.error!.localizedDescription), dismissButton: .default(Text("Retry"), action: { detailsScreenViewModel.fetchMovieDetails(movieId: movieId) }))
        }
        .onAppear {
            detailsScreenViewModel.fetchMovieDetails(movieId: movieId)
        }
    }
}

#Preview {
    DetailsScreenView(movieId: 11)
}
