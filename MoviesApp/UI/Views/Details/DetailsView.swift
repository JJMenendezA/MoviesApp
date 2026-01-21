//
//  DetailsView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 05/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: Router
    @EnvironmentObject var appSettings: AppSettings
    @StateObject var detailsViewModel: DetailsViewModel
    @State private var hasToastBeenTriggered: Bool = false
    @State private var productionCompanyName: String = ""
    @State private var toastWorkItem: DispatchWorkItem?
    var movieId: Int
    init(movieId: Int,
         service: MoviesService) {
        let repository = MoviesRepositoryImpl(moviesService: service)
        let useCase = FetchMovieDetailsImpl(repository: repository)
        self._detailsViewModel = StateObject(wrappedValue: DetailsViewModel(fetchMovieDetailsUseCase: useCase))
        self.movieId = movieId
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            if detailsViewModel.isLoading {
                SharedComponentsLoader()
            } else {
                if let movie = detailsViewModel.movieDetails {
                    VStack(spacing: 0) {
                        // MARK: - HEADER SECTION
                        DetailsComponentsHeader(title: movie.title,
                                                     action: { dismiss() },
                                                     closeAction: router.path.count > 1 ? { router.navigateBackToRoot() } : nil)
                        
                        ScrollView {
                            LazyVStack {
                                // MARK: - IMAGE AND TAGLINE SECTION
                                DetailsComponentsImageAndTagline(arrayImagePaths: [movie.moviePoster, movie.alternativeImage],
                                                                txtTagline: movie.tagline)
                                
                                DetailsComponentsRow(content: {
                                    DetailsComponentsItem(title: "Release date",
                                                         caption: movie.releaseDate.isEmpty ?
                                                          "No date available." : LocalizedStringResource(stringLiteral: movie.releaseDate))
                                    
                                    VStack {
                                        SharedComponentsSubtitle(text: "Vote average")
                                        // MARK: - STAR SECTION
                                        DetailsComponentsStars(stars: movie.stars, hasHalfStar: movie.hasHalfStar)
                                    } // :VStack
                                    .frame(width: 150)
                                })
                                
                                DetailsComponentsRow(content: {
                                    DetailsComponentsItem(title: "Language",
                                                          caption: LocalizedStringResource(stringLiteral:
                                                                                            (appSettings.locale.localizedString(
                                                                                                forLanguageCode: movie.language)
                                                                                             ?? movie.language)
                                                                                                .capitalized))
                                    DetailsComponentsItem(title: "Original title",
                                                          caption: LocalizedStringResource(stringLiteral: movie.title))
                                })
                                
                                DetailsComponentsRow(content: {
                                    DetailsComponentsItem(title: "Genres",
                                                          caption: LocalizedStringResource(stringLiteral: movie.genreList))
                                    DetailsComponentsItem(title: "Run time",
                                                         caption: movie.runtime == 0 ?
                                                         "No run time available." :
                                                            "\(movie.runtime) minutes")
                                })
                                
                                if !movie.overview.isEmpty {
                                    SharedComponentsSubtitle(text: "Overview")
                                    Text(movie.overview)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.bottom, 20)
                                }
                                
                                // MARK: - PRODUCTION COMPANIES
                                if !movie.productionCompanies.isEmpty {
                                    SharedComponentsSubtitle(text: "Production companies")
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
                                    SharedComponentsSubtitle(text: "Similar movies")
                                    SharedComponentsList(movies: movie.similarMoviesList)
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
            SharedComponentsToast(text: productionCompanyName,
                                 isToastActive: $hasToastBeenTriggered)
            
        } // :ZStack
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $detailsViewModel.hasErrorTriggered) {
            Alert(title: Text("Error"),
                  message: Text(detailsViewModel.error?.localizedDescription ?? "Something went wrong."),
                  dismissButton: .default(Text("Accept"), action: { dismiss() }))
        }
        .onAppear {
            Task {
                await detailsViewModel.fetchMovieDetails(movieId: movieId)
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
    DetailsView(movieId: 11, service: MoviesServiceImpl(languageProvider: { "en" }))
}
