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
                                DetailsImageAndTaglineComponent(moviePosters: [movie.moviePoster, movie.alternativeImage],
                                                                tagline: movie.tagline)
                                
                                DetailsRowComponent(content: {
                                    DetailsItemComponent(title: NSLocalizedString("Release date", comment: ""),
                                                         caption: movie.releaseDate.isEmpty ?
                                                         NSLocalizedString("No date available.", comment: "") : movie.releaseDate)
                                    
                                    VStack {
                                        SubtitleComponent(text: NSLocalizedString("Vote average", comment: ""))
                                        // MARK: - STAR SECTION
                                        DetailsStarsComponent(stars: movie.stars, hasHalfStar: movie.hasHalfStar)
                                    } // :VStack
                                    .frame(width: 150)
                                })
                                
                                DetailsRowComponent(content: {
                                    DetailsItemComponent(title: NSLocalizedString("Language", comment: ""),
                                                         caption: movie.language.capitalized)
                                    DetailsItemComponent(title: NSLocalizedString("Original title", comment: ""),
                                                         caption: movie.title)
                                })
                                
                                DetailsRowComponent(content: {
                                    DetailsItemComponent(title: NSLocalizedString("Genres", comment: ""),
                                                         caption: movie.genreList)
                                    DetailsItemComponent(title: NSLocalizedString("Run time", comment: ""),
                                                         caption: movie.runtime == 0 ?
                                                         NSLocalizedString("No run time available.", comment: "") :
                                                            String(movie.runtime) + " " + NSLocalizedString("minutes", comment: ""))
                                })
                                
                                if !movie.overview.isEmpty {
                                    SubtitleComponent(text: NSLocalizedString("Overview", comment: ""))
                                    Text(movie.overview)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 20)
                                }
                                
                                if let movieVideo = movie.movieVideo {
                                    SubtitleComponent(text: NSLocalizedString("Video reference", comment: ""), maxWidth: 200)
                                    VideoPlayer(videoURL: movieVideo)
                                        .frame(height: 300)
                                }
                                
                                if !movie.similarMoviesList.isEmpty {
                                    SubtitleComponent(text: NSLocalizedString("Similar movies", comment: ""))
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
