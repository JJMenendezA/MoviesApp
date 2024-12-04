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
                ProgressView()
                    .foregroundStyle(.white)
                    .tint(.white)
                    .offset(y: 75)
            }
           
            if !mainScreenViewModel.isLoading && mainScreenViewModel.error == nil {
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
                                if let randomMovie = mainScreenViewModel.randomMovie {
                                    HighlightMovieComponent(movie: randomMovie)
                                }
                                
                                // MARK: - ANNOUNCEMENTS SECTION
                                SubtitleComponent(text: "Important announcements 🗣️")
                                    .padding(.vertical, 10)
                                AnnouncementsComponent()
                            }
                            
                            // MARK: - SEARCH BAR SECTION
                            if !mainScreenViewModel.areFiltersApplied {
                                SearchBarComponent(textSearch: $mainScreenViewModel.searchTitle, isSearchBarFocused: $isSearchBarActive)
                                    .padding(.top, wasSearchMade ? 75 : 0)
                                    .id("SearchView")
                            }
                            
                            // MARK: - TOP RATED MOVIES SECTION
                            if let topRatedList = mainScreenViewModel.mutableMoviesLists[MovieTypes.topRated.title] {
                                if !topRatedList.isEmpty {
                                    MoviesListComponent(title: "Top Rated 🎟️", movies: topRatedList.sorted(by: { $0.vote_average > $1.vote_average }))
                                        .transition(.slide)
                                }
                                
                            }
                            
                            // MARK: - NOW PLAYING MOVIES SECTION
                            if let nowPlayingList = mainScreenViewModel.mutableMoviesLists[MovieTypes.nowPlaying.title] {
                                if !nowPlayingList.isEmpty {
                                    MoviesListComponent(title: "Now playing 🍿", movies: nowPlayingList)
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - POPULAR MOVIES SECTION
                            if let popularList = mainScreenViewModel.mutableMoviesLists[MovieTypes.popular.title] {
                                if !popularList.isEmpty {
                                    MoviesListComponent(title: "Popular movies 🎬", movies: popularList)
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - UPCOMING MOVIES SECTION
                            if let upcomingList = mainScreenViewModel.mutableMoviesLists[MovieTypes.upcoming.title] {
                                if !upcomingList.isEmpty {
                                    MoviesListComponent(title: "Upcoming 🎥", movies: upcomingList, isUpcoming: true)
                                        .transition(.slide)
                                }
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
                        .foregroundStyle(.white)
                    } // :ProgressView
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    Spacer()
                } // :VStack
                .controlSize(.large)
                .fontWeight(.bold)
            }
        } // :ZStack
        .background(.gray900)
        .ignoresSafeArea()
        .sheet(isPresented: $isBottomSheetActive) {
            FiltersScreenView(isSheetActive: $isBottomSheetActive, mainScreenViewModel: mainScreenViewModel)
                .presentationDetents([.height(400)])
        }
        .alert(isPresented: $mainScreenViewModel.hasErrorTrigerred){
            Alert(title: Text("Error"), message: Text(mainScreenViewModel.error!.localizedDescription), dismissButton: .default(Text("Retry"), action: { mainScreenViewModel.fetchMovies() }))
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
            
            if yOffset <  -100{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    mainScreenViewModel.isLoading = true
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}
