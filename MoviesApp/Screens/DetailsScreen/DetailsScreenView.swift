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
    @StateObject var detailsScreenViewModel: DetailsScreenViewModel = DetailsScreenViewModel()
    var movieId: Int
    var body: some View {
        ZStack {
            if detailsScreenViewModel.isLoading {
                LoaderComponent()
            } else {
                if let movie = detailsScreenViewModel.movieDetails {
                    VStack(spacing: 0) {
                        // MARK: - HEADER SECTION
                        ZStack(alignment: .leading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            })
                            .padding(.leading)
                            
                            HStack {
                                Spacer()
                                Text(movie.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .frame(maxWidth: 300)
                                Spacer()
                            } // :HStack
                        } // :ZStack
                        .padding(.bottom)
                        .background(.black)
                        .shadow(color: .black, radius: 10)
                        
                        ScrollView {
                            VStack {
                                if let moviePosterPath = movie.moviePoster {
                                    KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                                        .resizable()
                                        .frame(width: 300, height: 425)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 10)
                                        .padding(.bottom, 20)
                                }
                                
                                Text("\(movie.tagline)")
                                    .italic()
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, movie.tagline.isEmpty ? 0 : 20)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                
                                HStack {
                                    Spacer()
                                    VStack {
                                        DetailsScreenTitleComponent(text: "Release date")
                                        Text(movie.releaseDate.isEmpty ? "No date available." : movie.releaseDate)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                        
                                    } // :VStack
                                    .frame(width: 150)
                                    Spacer()
                                    
                                    VStack {
                                        DetailsScreenTitleComponent(text: "Vote average")
                                        
                                        // MARK: - STAR SECTION
                                        HStack {
                                            if movie.stars > 0 {
                                                ForEach(0..<movie.stars, id: \.self) { _ in
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
                                        DetailsScreenTitleComponent(text: "Original language")
                                        
                                        Text(movie.originalLanguage)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                    } // :VStack
                                    .frame(width: 150)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        DetailsScreenTitleComponent(text: "Original title")
                                        
                                        Text(movie.title)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                            .frame(height: 50)
                                    } // :VStack
                                    .frame(width: 150)
                                    Spacer()
                                } // :HStack
                                .padding(.bottom, 20)
                                
                                HStack {
                                    Spacer()
                                    VStack {
                                        DetailsScreenTitleComponent(text: "Genres")
                                        
                                        Text(movie.genreList)
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                    } // :VStack
                                    .frame(width: 150)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        DetailsScreenTitleComponent(text: "Run time")
                                        Text(movie.runtime == 0 ? "No run time available." : String(movie.runtime) + " minutes")
                                            .font(.body)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                            .multilineTextAlignment(.center)
                                        
                                    } // :VStack
                                    .frame(width: 150)
                                    
                                    Spacer()
                                } // :HStack
                                .padding(.bottom, 20)
                                
                                DetailsScreenTitleComponent(text: "Overview")
                                Text(movie.overview)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 20)
                                
                                if let movieVideo = movie.movieVideo {
                                    DetailsScreenTitleComponent(text: "Video reference")
                                    VideoPlayer(videoURL: movieVideo)
                                        .frame(height: 300)
                                }
                                
                                if !movie.similarMoviesList.isEmpty {
                                    DetailsScreenTitleComponent(text: "Similar movies")
                                    MoviesListComponent(movies: movie.similarMoviesList)
                                }
                                
                                Spacer()
                                
                            } // :VStack
                            .padding(.horizontal, 30)
                            .padding(.vertical)
                        } // :ScrollView
                    } // :VStack
                    .frame(maxWidth: .infinity)
                    .background(.gray900)
                } // :If let movieDetails
            }
        } // :ZStack
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $detailsScreenViewModel.hasErrorTrigerred) {
            Alert(title: Text("Error"),
                  message: Text(detailsScreenViewModel.error!.localizedDescription),
                  dismissButton: .default(Text("Accept"), action: { dismiss() }))
        }
        .onAppear {
            detailsScreenViewModel.fetchMovieDetails(movieId: movieId)
        }
    }
}

#Preview {
    DetailsScreenView(movieId: 11)
}
