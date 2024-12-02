//
//  MoviesView.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 21/10/24.
//

import SwiftUI
import Kingfisher

struct MainScreenView: View {
    @State private var isSearchBarActive: Bool = false
    @State private var yOffset: Double = 0.0
    @State private var backgroundHeaderColor: Color = .black.opacity(0.0)
    @State private var isBottomSheetActive: Bool = false
    @ObservedObject var mainScreenViewModel: MainScreenViewModel = MainScreenViewModel()
    // Computed properties
    private var wasSearchMade: Bool {
        if isSearchBarActive {
            true
        } else if !mainScreenViewModel.searchTitle.isEmpty {
            true
        } else {
            false
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if !mainScreenViewModel.isLoading {
                // MARK: - TOP SECTION
                MainHeaderComponent(color: backgroundHeaderColor, filterAction: {
                    isBottomSheetActive = true
                }, switchAction: {
                    
                }, submenuAction: {
                    
                }, areFiltersApplied: $mainScreenViewModel.areFiltersApplied)
                
                ScrollViewReader { reader in
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            if !wasSearchMade && !mainScreenViewModel.areFiltersApplied {
                                // MARK: - RANDOM PICK SECTION
                                HighlightMovieComponent(movie: ((mainScreenViewModel.mutableMoviesLists.isEmpty ? dummyMovieInfo : mainScreenViewModel.randomMovie)!))
                                
                                // MARK: - ANNOUNCEMENTS SECTION
                                SubtitleComponent(text: "Important announcements 🗣️")
                                    .padding(.vertical, 10)
                                AnnouncementsComponent()
                            }
                            
                            if !mainScreenViewModel.areFiltersApplied {
                                // MARK: - SEARCH BAR SECTION
                                SearchBarComponent(textSearch: $mainScreenViewModel.searchTitle, isSearchBarFocused: $isSearchBarActive)
                                    .padding(.top, wasSearchMade ? 75 : 0)
                                    .id("SearchView")
                            }
                            
                            if !mainScreenViewModel.mutableMoviesLists[MovieTypes.topRated.title]!.isEmpty {
                                // MARK: - TOP RATED MOVIES SECTION
                                MoviesListComponent(title: "Top Rated 🎟️", movies: mainScreenViewModel.mutableMoviesLists[MovieTypes.topRated.title]!.sorted(by: { $0.vote_average > $1.vote_average }), isPremiereSection: true)
                                    .transition(.slide)
                            }
                            
                            if !mainScreenViewModel.mutableMoviesLists[MovieTypes.nowPlaying.title]!.isEmpty {
                                // MARK: - NOW PLAYING MOVIES SECTION
                                MoviesListComponent(title: "Now playing 🍿", movies: mainScreenViewModel.mutableMoviesLists[MovieTypes.nowPlaying.title]!)
                                    .transition(.slide)
                            }
                            
                            if !mainScreenViewModel.mutableMoviesLists[MovieTypes.popular.title]!.isEmpty {
                                // MARK: - POPULAR MOVIES SECTION
                                MoviesListComponent(title: "Popular movies 🎬", movies: mainScreenViewModel.mutableMoviesLists[MovieTypes.popular.title]!)
                                    .transition(.slide)
                            }
                            
                            
                            if !mainScreenViewModel.mutableMoviesLists[MovieTypes.upcoming.title]!.isEmpty {
                                // MARK: - UPCOMING MOVIES SECTION
                                MoviesListComponent(title: "Upcoming 🎥", movies: mainScreenViewModel.mutableMoviesLists[MovieTypes.upcoming.title]!, isUpcoming: true)
                                    .transition(.slide)
                            }
                            
                            // MARK: - EMPTY RESULTS MESSAGE
                            if mainScreenViewModel.mutableMoviesLists.values.allSatisfy(\.isEmpty) {
                                NoMoviesComponent()
                                    .padding(.vertical, 50)
                            }
                        } // :VStack
                        .padding(.top, mainScreenViewModel.areFiltersApplied ? 75 : 0)
                    } // :ScrollView
                    .padding(.bottom)
                    // Scroll Geometry Reader to get the value of the y offset
                    .onScrollGeometryChange(for: Double.self) { geo in
                        geo.contentOffset.y
                    } action: { oldValue, newValue in
                        yOffset = newValue
                    }
                    .onChange(of: isSearchBarActive) {
                        if isSearchBarActive {
                            reader.scrollTo("SearchView", anchor: .top)
                        }
                    }
                } // :ScrollViewReader
            } else {
                // MARK: - LOADING SCREEN
                VStack{
                    Spacer()
                    ProgressView {
                        HStack{
                            Spacer()
                            Image(systemName: "hand.raised")
                            Text("Please wait...")
                            Spacer()
                        } // :HStack
                        .foregroundStyle(.pink700)
                    } // :ProgressView
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.pink700))
                    Spacer()
                } // :VStack
                .controlSize(.large)
            }
        } // :ZStack
        .background(.gray900)
        .ignoresSafeArea()
        .sheet(isPresented: $isBottomSheetActive) {
            FiltersView(isSheetActive: $isBottomSheetActive, mainScreenViewModel: mainScreenViewModel)
                .presentationDetents([.height(400)])
        }
        .onAppear{
            mainScreenViewModel.fetchMovies()
        }
        .onChange(of: isBottomSheetActive){
            if !isBottomSheetActive{
                withAnimation {
                    mainScreenViewModel.filterMovies()
                }
            }
        }
        .onChange(of: mainScreenViewModel.searchTitle){
            // Filtering the lists according to the search value
            withAnimation {
                mainScreenViewModel.searchMoviesByTitle()
            }
        }
        .onChange(of: yOffset){
            // Header background color opacity changes depending on the y offset
            backgroundHeaderColor = .black.opacity(yOffset/750)
        }
    }
}

#Preview {
    MainScreenView()
}
