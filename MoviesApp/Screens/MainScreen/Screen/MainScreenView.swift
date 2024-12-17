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
        NavigationView {
            ZStack(alignment: .top) {
                if mainScreenViewModel.error == nil && !mainScreenViewModel.mutableMoviesLists.isEmpty {
                    // MARK: - REFRESHER LOADER
                    if !mainScreenViewModel.areFiltersApplied && !wasSearchMade {
                        ProgressView()
                            .foregroundStyle(.white)
                            .tint(.white)
                            .offset(y: 75)
                            .controlSize(.large)
                    }
                    
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
                                    LeadAlignedView {
                                        DetailsScreenTitleComponent(text: "Important announcements", maxWidth: 250)
                                            .padding(.vertical, 10)
                                    } // :LeadAlignedView
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
                                        LeadAlignedView {
                                            DetailsScreenTitleComponent(text: "Top rated")
                                        } // :LeadAlignedView
                                        MoviesListComponent(movies: topRatedList.sorted(by: { $0.vote_average > $1.vote_average }))
                                            .transition(.slide)
                                    }
                                    
                                }
                                
                                // MARK: - NOW PLAYING MOVIES SECTION
                                if let nowPlayingList = mainScreenViewModel.mutableMoviesLists[MovieTypes.nowPlaying.title] {
                                    if !nowPlayingList.isEmpty {
                                        LeadAlignedView {
                                            DetailsScreenTitleComponent(text: "Now playing")
                                        } // :LeadAlignedView
                                        MoviesListComponent(movies: nowPlayingList)
                                            .transition(.slide)
                                    }
                                }
                                
                                // MARK: - POPULAR MOVIES SECTION
                                if let popularList = mainScreenViewModel.mutableMoviesLists[MovieTypes.popular.title] {
                                    if !popularList.isEmpty {
                                        LeadAlignedView {
                                            DetailsScreenTitleComponent(text: "Popular")
                                        } // :LeadAlignedView
                                        MoviesListComponent(movies: popularList)
                                            .transition(.slide)
                                    }
                                }
                                
                                // MARK: - UPCOMING MOVIES SECTION
                                if let upcomingList = mainScreenViewModel.mutableMoviesLists[MovieTypes.upcoming.title] {
                                    if !upcomingList.isEmpty {
                                        LeadAlignedView {
                                            DetailsScreenTitleComponent(text: "Upcoming")
                                        } // :LeadAlignedView
                                        MoviesListComponent(movies: upcomingList, isUpcoming: true)
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
                            .background(.gray900)
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
                }
                
                if mainScreenViewModel.isLoading {
                    // MARK: - LOADING SCREEN
                    LoaderComponent()
                        .zIndex(1)
                }
            } // :ZStack
            .background(.gray900)
            .ignoresSafeArea()
        }// :NavigationView
        .statusBar(hidden: true)
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
            
            // Trigger to refresh the data when offset passes -120
            if yOffset <  -120 && !mainScreenViewModel.isLoading && !mainScreenViewModel.areFiltersApplied && !wasSearchMade {
                mainScreenViewModel.isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    mainScreenViewModel.fetchMovies()
                }
            }
        }
    }
}

#Preview {
    MainScreenView()
}
