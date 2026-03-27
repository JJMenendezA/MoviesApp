//
//  MoviesView.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 21/10/24.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject private var mainViewModel: MainViewModel
    @State private var toastWorkItem: DispatchWorkItem?
    @State private var isSearchBarActive: Bool = false
    @State private var yOffset: Double = 0.0
    @State private var backgroundHeaderColor: Color = .black.opacity(0.0)
    @State private var isBottomSheetActive: Bool = false
    @State private var isUserDragging = false
    @State private var searchText: String = ""
    // Computed properties
    private var refreshText: String {
        rotateArrow ? "Release to refresh" : "Pull to refresh"
    }
    private var isSearchActive: Bool {
        isSearchBarActive || !searchText.isEmpty
    }
    private var hasScreenDragLimitBeenPassed: Bool {
        yOffset < -130
    }
    private var haveMoviesNotBeenFiltered: Bool {
        !mainViewModel.filterParameters.areFiltersApplied && !isSearchActive
    }
    private var isUserRefreshingMovies: Bool {
        !isUserDragging && hasScreenDragLimitBeenPassed && haveMoviesNotBeenFiltered
    }
    private var rotateArrow: Bool {
        hasScreenDragLimitBeenPassed && !mainViewModel.isInformationLoading && haveMoviesNotBeenFiltered
    }
    private var languageDescription: String {
        appSettings.locale.localizedString(forLanguageCode: appSettings.selectedLanguage)
                                   ?? appSettings.selectedLanguage
    }
    init(service: MoviesService) {
        let repository: MoviesRepository = MoviesRepositoryImpl(moviesService: service)
        let fetchMoviesUseCase: FetchMoviesUseCase = FetchMoviesUseCaseImpl(repository: repository)
        let fetchMovieUseCase: FetchMovieDetailsUseCase = FetchMovieDetailsImpl(repository: repository)
        self._mainViewModel = StateObject(wrappedValue: MainViewModel(fetchMoviesUseCase: fetchMoviesUseCase, fetchMovieUseCase: fetchMovieUseCase))
    }
    var body: some View {
        ZStack(alignment: .top) {
            if mainViewModel.error == nil && !mainViewModel.mutableMoviesDictionary.isEmpty {
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
                MainComponentsHeader(color: backgroundHeaderColor,
                                     filterAction: { isBottomSheetActive = true },
                                     showRatingAction: { appSettings.isShowingRating.toggle() },
                                     areFiltersApplied: mainViewModel.filterParameters.areFiltersApplied)
                
                ScrollViewReader { reader in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            if !isSearchActive && !mainViewModel.filterParameters.areFiltersApplied {
                                // MARK: - RANDOM PICK SECTION
                                if let randomMovie = mainViewModel.randomMovie {
                                    MainComponentsHighlight(movie: randomMovie)
                                }
                                
                                // MARK: - ANNOUNCEMENTS SECTION
                                SharedComponentsLeadAligned {
                                    SharedComponentsSubtitle(text: "Important announcements",
                                                             maxWidth: 250)
                                    .padding(.vertical, 10)
                                } // :LeadAlignedView
                                MainComponentsCarousel()
                            }
                            
                            // MARK: - SEARCH BAR SECTION
                            if !mainViewModel.filterParameters.areFiltersApplied {
                                MainComponentsSearchBar(textSearch: $searchText, isSearchBarFocused: $isSearchBarActive)
                                    .padding(.top, isSearchActive ? 75 : 0)
                                    .id("SearchView")
                            }
                            
                            // MARK: - TOP RATED MOVIES SECTION
                            if let topRatedList = mainViewModel.mutableMoviesDictionary[MovieTypes.topRated.title] {
                                if !topRatedList.moviesArray.isEmpty {
                                    MainComponentsList(title: "Top rated",
                                                       movies: topRatedList.moviesArray.sorted(by: { $0.voteAverage > $1.voteAverage }))
                                }
                            }
                            
                            // MARK: - NOW PLAYING MOVIES SECTION
                            if let nowPlayingList = mainViewModel.mutableMoviesDictionary[MovieTypes.nowPlaying.title] {
                                if !nowPlayingList.moviesArray.isEmpty {
                                    MainComponentsList(title: "Now playing",
                                                       movies: nowPlayingList.moviesArray)
                                }
                            }
                            
                            // MARK: - POPULAR MOVIES SECTION
                            if let popularList = mainViewModel.mutableMoviesDictionary[MovieTypes.popular.title] {
                                if !popularList.moviesArray.isEmpty {
                                    MainComponentsList(title: "Popular",
                                                       movies: popularList.moviesArray)
                                }
                            }
                            
                            // MARK: - UPCOMING MOVIES SECTION
                            if let upcomingList = mainViewModel.mutableMoviesDictionary[MovieTypes.upcoming.title] {
                                if !upcomingList.moviesArray.isEmpty {
                                    MainComponentsList(title: "Upcoming",
                                                       movies: upcomingList.moviesArray,
                                                       isUpcoming: true)
                                }
                            }
                            
                            // MARK: - EMPTY RESULTS MESSAGE
                            if mainViewModel.mutableMoviesDictionary.values.filter({ !$0.moviesArray.isEmpty }).isEmpty {
                                MainComponentsNoMovies()
                                    .padding(.vertical, 50)
                            }
                        } // :VStack
                        .padding(.top, mainViewModel.filterParameters.areFiltersApplied ? 75 : 0)
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
            
            // MARK: - TOAST COMPONENT
            VStack {
                Spacer()
                SharedComponentsToast(textLocalized: "The language has changed to \(languageDescription)",
                                      isToastActive: $mainViewModel.hasToastBeenTriggered)
            } // :VStack
            .padding(.bottom)
                
            if mainViewModel.isInformationLoading {
                // MARK: - LOADING SCREEN
                SharedComponentsLoader()
                    .zIndex(1)
            }
        } // :ZStack
        .background(.gray900)
        .ignoresSafeArea()
        .environmentObject(appSettings)
        .sheet(isPresented: $isBottomSheetActive) {
            FiltersSheet(isSheetActive: $isBottomSheetActive, mainViewModel: mainViewModel)
                .presentationDetents([.height(400)])
        }
        .alert(isPresented: $mainViewModel.hasErrorBeenTriggered) {
            Alert(title: Text("Error"),
                  message: Text(mainViewModel.error?.localizedDescription ?? "Something went wrong."),
                  dismissButton: .default(Text("Retry"),
                                          action: {
                Task { await mainViewModel.fetchMovies() }
            }))
        }
        .onAppear {
            if !mainViewModel.hasInformationLoaded {
                Task { await mainViewModel.fetchMovies() }
            }
        }
        .onChange(of: isBottomSheetActive) {
            if !isBottomSheetActive {
                withAnimation {
                    mainViewModel.filterMovies()
                }
            }
        }
        .onChange(of: searchText) {
            // Filtering the lists according to the search value
            withAnimation {
                mainViewModel.searchMoviesByTitle(title: searchText)
            }
        }
        .onChange(of: yOffset) {
            // Header background color opacity changes depending on the y offset
            backgroundHeaderColor = .black.opacity(yOffset/750)
        }
        .onChange(of: isUserDragging) {
            if isUserRefreshingMovies {
                mainViewModel.isInformationLoading = true
                Task {
                    try? await Task.sleep(for: .seconds(1.5))
                    await mainViewModel.fetchMovies()
                }
            }
        }
        .onChange(of: appSettings.selectedLanguage) {
            mainViewModel.isInformationLoading = true
            Task {
                try? await Task.sleep(for: .seconds(1.5))
                await mainViewModel.fetchMovies(hasLanguageChanged: true)
            }
        }
        // MARK: - TOAST TIMER
        .onChange(of: mainViewModel.hasToastBeenTriggered) {
            if mainViewModel.hasToastBeenTriggered {
                scheduleToastDismissal()
            }
        }
    }
    func scheduleToastDismissal() {
        toastWorkItem?.cancel()
        let work = DispatchWorkItem {
            withAnimation { mainViewModel.hasToastBeenTriggered = false }
        }
        toastWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: work)
    }
}

#Preview {
    MainView(service: MoviesServiceImpl(languageProvider: { "en" }))
}
