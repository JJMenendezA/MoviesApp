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
    @StateObject var detailsScreenViewModel: DetailsScreenViewModel
    var movieId: Int
    init(movieId: Int) {
        let service = MoviesServiceImpl()
        let repository = MoviesRepositoryImpl(moviesService: service)
        let useCase = FetchMovieDetailsImpl(repository: repository)
        self._detailsScreenViewModel = StateObject(wrappedValue: DetailsScreenViewModel(fetchMovieDetailsUseCase: useCase))
        self.movieId = movieId
    }
    var body: some View {
        ZStack {
            if detailsScreenViewModel.isLoading {
                LoaderComponent()
            } else {
                if let movie = detailsScreenViewModel.movieDetails {
                    VStack(spacing: 0) {
                        // MARK: - HEADER SECTION
                        DetailsScreenHeaderComponent(title: movie.title,
                                                     action: { dismiss() })
                        
                        ScrollView {
                            LazyVStack {
                                // MARK: - IMAGE AND TAGLINE SECTION
                                DetailsImageAndTaglineComponent(moviePoster: movie.moviePoster,
                                                                tagline: movie.tagline)
                                
                                HStack {
                                    Spacer()
                                    
                                    DetailsItemComponent(title: NSLocalizedString("Release date", comment: ""),
                                                         caption: movie.releaseDate.isEmpty ?
                                                         NSLocalizedString("No date available.", comment: "") : movie.releaseDate)
                                    Spacer()
                                    
                                    VStack {
                                        DetailsScreenTitleComponent(text: NSLocalizedString("Vote average", comment: ""))
                                        
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
                                
                                DetailsRowComponent(firstView: {
                                    DetailsItemComponent(title: NSLocalizedString("Original language", comment: ""),
                                                         caption: movie.originalLanguage.capitalized)
                                }, secondView: {
                                    DetailsItemComponent(title: NSLocalizedString("Original title", comment: ""),
                                                         caption: movie.title)
                                })
                                
                                DetailsRowComponent(firstView: {
                                    DetailsItemComponent(title: NSLocalizedString("Genres", comment: ""),
                                                         caption: movie.genreList)
                                }, secondView: {
                                    DetailsItemComponent(title: NSLocalizedString("Run time", comment: ""),
                                                         caption: movie.runtime == 0 ?
                                                         NSLocalizedString("No run time available.", comment: "") :
                                                            String(movie.runtime) + " " + NSLocalizedString("minutes", comment: ""))
                                })
                                
                                if !movie.overview.isEmpty {
                                    DetailsScreenTitleComponent(text: NSLocalizedString("Overview", comment: ""))
                                    Text(movie.overview)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 20)
                                }
                                
                                if let movieVideo = movie.movieVideo {
                                    DetailsScreenTitleComponent(text: NSLocalizedString("Video reference", comment: ""), maxWidth: 200)
                                    VideoPlayer(videoURL: movieVideo)
                                        .frame(height: 300)
                                }
                                
                                if !movie.similarMoviesList.isEmpty {
                                    DetailsScreenTitleComponent(text: NSLocalizedString("Similar movies", comment: ""))
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
        .alert(isPresented: $detailsScreenViewModel.hasErrorTriggered) {
            Alert(title: Text("Error"),
                  message: Text(detailsScreenViewModel.error?.localizedDescription ?? NSLocalizedString("Something went wrong.", comment: "")),
                  dismissButton: .default(Text("Accept"), action: { dismiss() }))
        }
        .onAppear {
            Task {
                await detailsScreenViewModel.fetchMovieDetails(movieId: movieId)
            }
        }
    }
}

#Preview {
    DetailsScreenView(movieId: 11)
}
