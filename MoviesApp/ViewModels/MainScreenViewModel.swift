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
    var moviesDictionary: [String : Movies] = [:]
    // Mutable lists
    @Published var mutableMoviesLists: [String : [MovieInfo]] = [:]
    var randomMovie: MovieInfo?
    // Error and Loading States
    @Published private var errorTriggered: Error?
    @Published var isLoading: Bool = true
    // Filter lists
    @Published var originalLanguagesList: [String] = []
    @Published var releaseDatesList: [Date] = []
    // Search and filter variables
    @Published var searchTitle: String = ""
    @Published var filterLanguage: String = "All languages"
    @Published var filterStartReleaseDate: Date = Date()
    @Published var filterEndReleaseDate: Date = Date()
    @Published var areFiltersApplied: Bool = false
    
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MoviesService()) {
        self.moviesService = moviesService
    }
    
    func fetchMovies() {
        isLoading = true
        moviesService.fetchAllMovies(completion: { [weak self] result in
            switch result {
            case .success(let fetchedMovies):
                self?.moviesDictionary = fetchedMovies
                self?.randomMovie = self?.moviesDictionary.values.randomElement()?.results.randomElement()
                self?.setLists()
                self?.originalLanguagesList = (self?.createLanguageList())!
                self?.releaseDatesList = (self?.createDateListAndSetVariables())!
                self?.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                self?.isLoading = false
            }
            
        })
    }
    
    private func setLists() {
        moviesDictionary.forEach({ movie in
            switch movie.key {
            case MovieTypes.popular.title, MovieTypes.topRated.title:
                mutableMoviesLists[movie.key] = movie.value.results
            case MovieTypes.nowPlaying.title:
                mutableMoviesLists[movie.key] = movie.value.results.filter({ $0.release_date <= getTodaysDate() && $0.release_date >= getTwoWeeksAgoDate()})
            case MovieTypes.upcoming.title:
                mutableMoviesLists[movie.key] = movie.value.results.filter({ $0.release_date > getTodaysDate()})
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
    
    private func createDateListAndSetVariables() -> [Date] {
        var dateSet: Set<Date> = []
        moviesDictionary.forEach({ movie in
            dateSet.formUnion(movie.value.releaseDatesSet)
        })
        
        filterStartReleaseDate = Array(dateSet).sorted().first!
        filterEndReleaseDate = Array(dateSet).sorted().last!
        
        return Array(dateSet).sorted()
    }
    
    func searchMoviesByTitle() {
        guard !searchTitle.isEmpty else {
            setLists()
            return
        }
        
        moviesDictionary.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.results.filter({ movie in
                movie.title.localizedCaseInsensitiveContains(searchTitle)
            })
        })
    }
    
    private func filterMoviesByDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        mutableMoviesLists.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.filter({ movie in
                dateFormatter.date(from: movie.release_date)! >= filterStartReleaseDate && dateFormatter.date(from: movie.release_date)! <= filterEndReleaseDate
            })
        })
    }
    
    private func filterMoviesByLanguage() {
        mutableMoviesLists.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.filter({ movie in
                Locale.current.localizedString(forLanguageCode: movie.original_language) == filterLanguage
            })
        })
    }
    
    func filterMovies(){
        setLists()
        
        guard areFiltersApplied else {
            return
        }
        
        if filterLanguage != "All languages" {
            filterMoviesByLanguage()
        }
        
        if filterStartReleaseDate != releaseDatesList.first! || filterEndReleaseDate != releaseDatesList.last! {
            filterMoviesByDate()
        }
    }
    
    func cleanFilters() {
        filterStartReleaseDate = Array(releaseDatesList).sorted().first!
        filterEndReleaseDate = Array(releaseDatesList).sorted().last!
        filterLanguage = "All languages"
        areFiltersApplied = false
    }
    
}



