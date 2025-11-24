//
//  MoviesView.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 21/10/24.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    @State private var isSearchBarActive: Bool = false
    @State private var yOffset: Double = 0.0
    @State private var backgroundHeaderColor: Color = .black.opacity(0.0)
    @State private var isBottomSheetActive: Bool = false
    @State private var isUserDragging = false
    @State private var searchText: String = ""
    @StateObject var mainScreenViewModel: MainViewModel
    // Computed properties
    private var refreshText: String {
        rotateArrow ? NSLocalizedString("Release to refresh", comment: "") : NSLocalizedString("Pull to refresh", comment: "")
    }
    private var isSearchActive: Bool {
        isSearchBarActive || !searchText.isEmpty
    }
    private var hasScreenDragLimitBeenPassed: Bool {
        yOffset < -130
    }
    private var haveMoviesNotBeenFiltered: Bool {
        !mainScreenViewModel.filterParameters.areFiltersApplied && !isSearchActive
    }
    private var isUserRefreshingMovies: Bool {
        !isUserDragging && hasScreenDragLimitBeenPassed && haveMoviesNotBeenFiltered
    }
    private var rotateArrow: Bool {
        hasScreenDragLimitBeenPassed && !mainScreenViewModel.isInformationLoading && haveMoviesNotBeenFiltered
    }
    init() {
        let service: MoviesService = MoviesServiceImpl()
        let repository: MoviesRepository = MoviesRepositoryImpl(moviesService: service)
        let useCase: FetchMoviesUseCase = FetchMoviesUseCaseImpl(repository: repository)
        self._mainScreenViewModel = StateObject(wrappedValue: MainViewModel(fetchMoviesUseCase: useCase))
    }
    var body: some View {
        ZStack(alignment: .top) {
            if mainScreenViewModel.error == nil && !mainScreenViewModel.mutableMoviesDictionary.isEmpty {
                // MARK: - REFRESHER LOADER
                if haveMoviesNotBeenFiltered {
                    VStack {
                        Image(systemName: "arrowshape.down.fill")
                            .rotationEffect(.degrees(rotateArrow ? 180 : 0))
                            .animation(.easeInOut, value: rotateArrow)
                        Text(refreshText)
                    }
                    .foregroundStyle(.white)
                    .tint(.white)
                    .offset(y: 75)
                    .controlSize(.large)
                }
                
                // MARK: - TOP SECTION
                MainHeaderComponent(color: backgroundHeaderColor,
                                    filterAction: { isBottomSheetActive = true },
                                    switchAction: {},
                                    submenuAction: {},
                                    areFiltersApplied: mainScreenViewModel.filterParameters.areFiltersApplied)
                
                ScrollViewReader { reader in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            if !isSearchActive && !mainScreenViewModel.filterParameters.areFiltersApplied {
                                // MARK: - RANDOM PICK SECTION
                                if let randomMovie = mainScreenViewModel.randomMovie {
                                    HighlightMovieComponent(movie: randomMovie)
                                }
                                
                                // MARK: - ANNOUNCEMENTS SECTION
                                LeadAlignedView {
                                    SubtitleComponent(text: NSLocalizedString("Important announcements", comment: ""),
                                                      maxWidth: 250)
                                    .padding(.vertical, 10)
                                } // :LeadAlignedView
                                AnnouncementsComponent()
                            }
                            
                            // MARK: - SEARCH BAR SECTION
                            if !mainScreenViewModel.filterParameters.areFiltersApplied {
                                SearchBarComponent(textSearch: $searchText, isSearchBarFocused: $isSearchBarActive)
                                    .padding(.top, isSearchActive ? 75 : 0)
                                    .id("SearchView")
                            }
                            
                            // MARK: - TOP RATED MOVIES SECTION
                            if let topRatedList = mainScreenViewModel.mutableMoviesDictionary[MovieTypes.topRated.title] {
                                if !topRatedList.isEmpty {
                                    MoviesListTitleComponent(title: "Top rated")
                                    MoviesListComponent(movies: topRatedList.sorted(by: { $0.voteAverage > $1.voteAverage }))
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - NOW PLAYING MOVIES SECTION
                            if let nowPlayingList = mainScreenViewModel.mutableMoviesDictionary[MovieTypes.nowPlaying.title] {
                                if !nowPlayingList.isEmpty {
                                    MoviesListTitleComponent(title: "Now playing")
                                    MoviesListComponent(movies: nowPlayingList)
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - POPULAR MOVIES SECTION
                            if let popularList = mainScreenViewModel.mutableMoviesDictionary[MovieTypes.popular.title] {
                                if !popularList.isEmpty {
                                    MoviesListTitleComponent(title: "Popular")
                                    MoviesListComponent(movies: popularList)
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - UPCOMING MOVIES SECTION
                            if let upcomingList = mainScreenViewModel.mutableMoviesDictionary[MovieTypes.upcoming.title] {
                                if !upcomingList.isEmpty {
                                    MoviesListTitleComponent(title: "Upcoming")
                                    MoviesListComponent(movies: upcomingList, isUpcoming: true)
                                        .transition(.slide)
                                }
                            }
                            
                            // MARK: - EMPTY RESULTS MESSAGE
                            if mainScreenViewModel.mutableMoviesDictionary.values.allSatisfy(\.isEmpty) {
                                NoMoviesComponent()
                                    .padding(.vertical, 50)
                            }
                        } // :VStack
                        .padding(.top, mainScreenViewModel.filterParameters.areFiltersApplied ? 75 : 0)
                        .background(.gray900)
                    } // :ScrollView
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                if !isUserDragging { isUserDragging = true }
                            }
                            .onEnded { _ in
                                isUserDragging = false
                            }
                    )
                    .padding(.bottom)
                    // Scroll Geometry Reader to get the value of the y offset
                    .onScrollGeometryChange(for: Double.self) { geo in
                        geo.contentOffset.y
                    } action: { _, newValue in
                        yOffset = newValue
                    }
                    .onChange(of: isSearchBarActive) {
                        if isSearchBarActive {
                            reader.scrollTo("SearchView", anchor: .top)
                        }
                    }
                } // :ScrollViewReader
            }
            
            if mainScreenViewModel.isInformationLoading {
                // MARK: - LOADING SCREEN
                LoaderComponent()
                    .zIndex(1)
            }
        } // :ZStack
        .background(.gray900)
        .ignoresSafeArea()
        .sheet(isPresented: $isBottomSheetActive) {
            FiltersSheetView(isSheetActive: $isBottomSheetActive, mainScreenViewModel: mainScreenViewModel)
                .presentationDetents([.height(400)])
        }
        .alert(isPresented: $mainScreenViewModel.hasErrorBeenTriggered) {
            Alert(title: Text("Error"),
                  message: Text(mainScreenViewModel.error?.localizedDescription ?? NSLocalizedString("Something went wrong.", comment: "")),
                  dismissButton: .default(Text("Retry"),
                                          action: {
                Task { await mainScreenViewModel.fetchMovies() }
            }))
        }
        .onAppear {
            if !mainScreenViewModel.hasInformationLoaded {
                Task { await mainScreenViewModel.fetchMovies() }
            }
        }
        .onChange(of: isBottomSheetActive) {
            if !isBottomSheetActive {
                withAnimation {
                    mainScreenViewModel.filterMovies()
                }
            }
        }
        .onChange(of: searchText) {
            // Filtering the lists according to the search value
            withAnimation {
                mainScreenViewModel.searchMoviesByTitle(title: searchText)
            }
        }
        .onChange(of: yOffset) {
            // Header background color opacity changes depending on the y offset
            backgroundHeaderColor = .black.opacity(yOffset/750)
        }
        .onChange(of: isUserDragging) {
            if isUserRefreshingMovies {
                mainScreenViewModel.isInformationLoading = true
                Task {
                    try? await Task.sleep(for: .seconds(1.5))
                    await mainScreenViewModel.fetchMovies()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
