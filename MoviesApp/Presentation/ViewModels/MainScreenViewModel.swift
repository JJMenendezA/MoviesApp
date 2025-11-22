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
    var moviesDictionary: [String: MoviesResponse] = [:]
    @Published var mutableMoviesDictionary: [String: [MovieEntity]] = [:]
    var randomMovie: MovieEntity?
    
    @Published var error: AppError?
    @Published var hasErrorBeenTriggered: Bool = false
    
    @Published var isInformationLoading: Bool = true
    @Published var hasInformationLoaded: Bool = false
    @Published var languagesArray: [String] = []
    @Published var releaseDatesArray: [Date] = []
    @Published var filterParameters: FilterParameters = FilterParameters()
    
    private let fetchMoviesUseCase: FetchMoviesUseCase
    init(fetchMoviesUseCase: FetchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }
    
    @MainActor
    func fetchMovies() async {
        isInformationLoading = true
        do {
            moviesDictionary = try await fetchMoviesUseCase.fetch()
            if  let randomList = self.moviesDictionary.values.randomElement(),
                let randomMovie = randomList.results.randomElement() {
                self.randomMovie = MovieEntity(from: randomMovie)
            }
            setMutableMovieDictionary()
            setDateArray()
            setLanguageArray()
            setDefaultDateVariables()
            isInformationLoading = false
            hasInformationLoaded = true
        } catch let error as AppError {
            triggerErrorAlert(appError: error)
        } catch {
            triggerErrorAlert(appError:
                                AppError.unknown(localizedDesciption: error.localizedDescription))
        }
    }
    
    func setMutableMovieDictionary() {
        moviesDictionary.forEach({ movie in
            switch movie.key {
            case MovieTypes.popular.title, MovieTypes.topRated.title:
                mutableMoviesDictionary[movie.key] = movie.value.results
                    .map({ movie in
                        MovieEntity(from: movie)
                    })
            case MovieTypes.nowPlaying.title:
                mutableMoviesDictionary[movie.key] = movie.value.results
                    .sorted(by: { $0.release_date < $1.release_date })
                    .map({ movie in
                        MovieEntity(from: movie)
                    })
            case MovieTypes.upcoming.title:
                mutableMoviesDictionary[movie.key] = movie.value.results
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
    
    func setLanguageArray() {
        languagesArray = createLanguageList()
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
    
    func setDateArray() {
        releaseDatesArray = createDatesList()
    }
    
    private func createDatesList() -> [Date] {
        var dateSet: Set<Date> = []
        moviesDictionary.forEach({ movie in
            dateSet.formUnion(movie.value.releaseDatesSet)
        })
        
        return Array(dateSet).sorted()
    }
    
    func setDefaultDateVariables() {
        if let startDate = releaseDatesArray.sorted().first,
           let endDate = releaseDatesArray.sorted().last {
            filterParameters.setDefaultValues(startDate: startDate, endDate: endDate)
        }
    }
    
    func searchMoviesByTitle(title: String) {
        guard !title.isEmpty else {
            setMutableMovieDictionary()
            return
        }
        
        moviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key] = movie.value.results.filter({ movie in
                movie.title.localizedCaseInsensitiveContains(title)
            }).map({ movie in
                MovieEntity(from: movie)
            })
        })
    }
    
    private func filterMoviesByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key] = movie.value.filter({ movie in
                dateFormatter.date(from: movie.releaseDate) ?? Date() >= filterParameters.startDate &&
                dateFormatter.date(from: movie.releaseDate) ?? Date() <= filterParameters.endDate
            })
        })
    }
    
    private func filterMoviesByLanguage() {
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key] = movie.value.filter({ movie in
                Locale.current.localizedString(forLanguageCode: movie.originalLanguage) == filterParameters.language
            })
        })
    }
    
    func filterMovies() {
        setMutableMovieDictionary()
        
        guard filterParameters.areFiltersApplied else { return }
        
        if filterParameters.language != NSLocalizedString("All languages", comment: "") {
            filterMoviesByLanguage()
        }
        
        if let firstDate = releaseDatesArray.first,
           let lastDate = releaseDatesArray.last {
            if filterParameters.startDate != firstDate ||
                filterParameters.endDate != lastDate { filterMoviesByDate() }
        }
    }
    
    private func triggerErrorAlert(appError: AppError) {
        error = appError
        hasErrorBeenTriggered = true
        isInformationLoading = false
    }
}
