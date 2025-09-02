//
//  MainScreenViewModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 18/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation
import SwiftUI

class MainScreenViewModel: ObservableObject {
    // Immutable lists
    var moviesDictionary: [String: MoviesResponse] = [:]
    // Mutable lists
    @Published var mutableMoviesLists: [String: [MovieEntity]] = [:]
    // Random movie to showcase
    var randomMovie: MovieEntity?
    // Error and Loading States
    @Published var error: AppError?
    @Published var hasErrorTriggered: Bool = false
    @Published var isLoading: Bool = true
    // Filter lists
    @Published var languagesList: [String] = []
    @Published var releaseDatesList: [Date] = []
    // Filter variables
    @Published var filterParameters: FilterParameters = FilterParameters()
    
    private let fetchMoviesUseCase: FetchMoviesUseCase
    init(fetchMoviesUseCase: FetchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }
    
    @MainActor
    func fetchMovies() async {
        isLoading = true
        do {
            moviesDictionary = try await fetchMoviesUseCase.fetch()
            if  let randomList = self.moviesDictionary.values.randomElement(),
                let randomMovie = randomList.results.randomElement() {
                self.randomMovie = MovieEntity(from: randomMovie)
            }
            setLists()
            languagesList = createLanguageList()
            releaseDatesList = createDatesList()
            setDefaultDateVariables()
            isLoading = false
        } catch let error as AppError {
            triggerErrorAlert(appError: error)
        } catch {
            triggerErrorAlert(appError:
                                AppError.unknown(localizedDesciption: error.localizedDescription))
        }
    }
    
    private func setLists() {
        moviesDictionary.forEach({ movie in
            switch movie.key {
            case MovieTypes.popular.title, MovieTypes.topRated.title:
                mutableMoviesLists[movie.key] = movie.value.results.map({ movie in
                    MovieEntity(from: movie)
                })
            case MovieTypes.nowPlaying.title:
                mutableMoviesLists[movie.key] = movie.value.results.sorted(by: { $0.release_date < $1.release_date }).map({ movie in
                    MovieEntity(from: movie)
                })
            case MovieTypes.upcoming.title:
                mutableMoviesLists[movie.key] = movie.value.results
                    .filter({ $0.release_date > getTwoWeeksAgoDate()})
                    .sorted(by: { $0.release_date < $1.release_date })
                    .map({ movie in
                    MovieEntity(from: movie)
                })
            default:
                break
            }
        })        
    }
    
    private func createLanguageList() -> [String] {
        var languageSet: Set<String> = []
        moviesDictionary.forEach({ movie in
            languageSet.formUnion(movie.value.originalLanguagesSet)
        })
        
        var sortedLanguageList = Array(languageSet).sorted()
        
        sortedLanguageList.insert("All languages", at: 0)
        
        return sortedLanguageList
    }
    
    private func createDatesList() -> [Date] {
        var dateSet: Set<Date> = []
        moviesDictionary.forEach({ movie in
            dateSet.formUnion(movie.value.releaseDatesSet)
        })
        
        return Array(dateSet).sorted()
    }
    
    func setDefaultDateVariables() {
        if let startDate = releaseDatesList.sorted().first,
            let endDate = releaseDatesList.sorted().last {
            filterParameters.setDefaultValues(startDate: startDate, endDate: endDate)
        }
    }
    
    func searchMoviesByTitle(title: String) {
        guard !title.isEmpty else {
            setLists()
            return
        }
        
        moviesDictionary.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.results.filter({ movie in
                movie.title.localizedCaseInsensitiveContains(title)
            }).map({ movie in
                MovieEntity(from: movie)
            })
        })
    }
    
    private func filterMoviesByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        mutableMoviesLists.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.filter({ movie in
                dateFormatter.date(from: movie.releaseDate) ?? Date() >= filterParameters.filterStartReleaseDate &&
                dateFormatter.date(from: movie.releaseDate) ?? Date() <= filterParameters.filterEndReleaseDate
            })
        })
    }
    
    private func filterMoviesByLanguage() {
        mutableMoviesLists.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.filter({ movie in
                Locale.current.localizedString(forLanguageCode: movie.originalLanguage) == filterParameters.filterLanguage
            })
        })
    }
    
    func filterMovies() {
        setLists()
        
        guard filterParameters.areFiltersApplied else { return }
        
        if filterParameters.filterLanguage != NSLocalizedString("All languages", comment: "") {
            filterMoviesByLanguage()
        }
        
        if let firstDate = releaseDatesList.first,
           let lastDate = releaseDatesList.last {
            if filterParameters.filterStartReleaseDate != firstDate ||
                filterParameters.filterEndReleaseDate != lastDate { filterMoviesByDate() }
        }
    }
    
    private func triggerErrorAlert(appError: AppError) {
        error = appError
        hasErrorTriggered = true
        isLoading = false
    }
}
