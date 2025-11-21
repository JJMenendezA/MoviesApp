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
    @State private var hasToastBeenTriggered: Bool = false
    @State private var productionCompanyName: String = ""
    @State private var toastWorkItem: DispatchWorkItem?
    var movieId: Int
    init(movieId: Int) {
        let service = MoviesServiceImpl()
        let repository = MoviesRepositoryImpl(moviesService: service)
        let useCase = FetchMovieDetailsImpl(repository: repository)
        self._detailsScreenViewModel = StateObject(wrappedValue: DetailsScreenViewModel(fetchMovieDetailsUseCase: useCase))
        self.movieId = movieId
    }
    var body: some View {
        ZStack(alignment: .bottom) {
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
                                DetailsImageAndTaglineComponent(arrayImagePaths: [movie.moviePoster, movie.alternativeImage],
                                                                txtTagline: movie.tagline)
                                
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
                                
                                // MARK: - PRODUCTION COMPANIES (TO FINISH)
                                if !movie.productionCompanies.isEmpty {
                                    SubtitleComponent(text: NSLocalizedString("Production companies", comment: ""))
                                    ScrollView(.horizontal) {
                                        LazyHStack {
                                            ForEach(movie.productionCompanies, id: \.self) { productionCompany in
                                                if let logoPath = productionCompany.logoPath,
                                                   let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
                                                    Button(action: {
                                                        if !hasToastBeenTriggered {
                                                            productionCompanyName = productionCompany.name
                                                            withAnimation {
                                                                hasToastBeenTriggered = true
                                                            }
                                                        } else {
                                                            if productionCompanyName != productionCompany.name {
                                                                productionCompanyName = productionCompany.name
                                                                scheduleToastDismissal()
                                                            }
                                                        }
                                                    }, label: {
                                                        KFImage(movieImageURL.appendingPathComponent(logoPath))
                                                            .resizable()
                                                            .frame(width: 100, height: 50)
                                                            .padding()
                                                            .background {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .fill(customLinearGradient(colors: [.black, .white]).opacity(0.5))
                                                            }
                                                    })
                                                } else {
                                                    VStack {
                                                        Text(productionCompany.name)
                                                            .minimumScaleFactor(0.2)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundStyle(.white)
                                                    } // :VStack
                                                    .frame(width: 100, height: 50)
                                                    .foregroundStyle(.black)
                                                    .padding()
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(customLinearGradient(colors: [.black, .white]).opacity(0.5))
                                                    }
                                                }
                                            }
                                        } // :HStack
                                    } // :ScrollView
                                    .scrollIndicators(.hidden)
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
            
            // MARK: - TOAST COMPONENT
            RoundedRectangle(cornerRadius: 10)
                .fill(.black)
                .overlay {
                    Text(productionCompanyName)
                }
                .frame(height: 50)
                .padding()
                .opacity(hasToastBeenTriggered ? 1 : 0)
            
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
        // MARK: - TOAST TIMER
        .onChange(of: hasToastBeenTriggered) {
            if hasToastBeenTriggered {
                scheduleToastDismissal()
            }
        }
    }
    func scheduleToastDismissal() {
        toastWorkItem?.cancel()
        let work = DispatchWorkItem {
            withAnimation { hasToastBeenTriggered = false }
        }
        toastWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
    }
}

#Preview {
    DetailsScreenView(movieId: 11)
}
