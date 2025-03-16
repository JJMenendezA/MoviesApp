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
    @Published var error: AppError?
    @Published var hasErrorTrigerred: Bool = false
    @Published var isLoading: Bool = true
    // Filter lists
    @Published var originalLanguagesList: [String] = []
    @Published var releaseDatesList: [Date] = []
    // Search and filter variables
    @Published var searchTitle: String = ""
    @Published var filterParameters: FilterParameters = FilterParameters()
    
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
                self?.error = error
                self?.hasErrorTrigerred = true
                self?.isLoading = false
            }
            
        })
    }
    
    private func setLists() {
        moviesDictionary.forEach({ movie in
            switch movie.key {
            case MovieTypes.popular.title, MovieTypes.topRated.title:
                mutableMoviesLists[movie.key] = movie.value.results
            case MovieTypes.nowPlaying.title, MovieTypes.upcoming.title:
                mutableMoviesLists[movie.key] = movie.value.results.sorted(by: { $0.release_date < $1.release_date })
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
        
        filterParameters.filterStartReleaseDate = Array(dateSet).sorted().first!
        filterParameters.filterEndReleaseDate = Array(dateSet).sorted().last!
        
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
                dateFormatter.date(from: movie.release_date)! >= filterParameters.filterStartReleaseDate && dateFormatter.date(from: movie.release_date)! <= filterParameters.filterEndReleaseDate
            })
        })
    }
    
    private func filterMoviesByLanguage() {
        mutableMoviesLists.forEach({ movie in
            mutableMoviesLists[movie.key] = movie.value.filter({ movie in
                Locale.current.localizedString(forLanguageCode: movie.original_language) == filterParameters.filterLanguage
            })
        })
    }
    
    func filterMovies(){
        setLists()
        
        guard filterParameters.areFiltersApplied else { return }
        
        if filterParameters.filterLanguage != "All languages" { filterMoviesByLanguage() }
        
        if filterParameters.filterStartReleaseDate != releaseDatesList.first! || filterParameters.filterEndReleaseDate != releaseDatesList.last! { filterMoviesByDate() }
    }
    
    func cleanFilters() {
        filterParameters.filterStartReleaseDate = Array(releaseDatesList).sorted().first!
        filterParameters.filterEndReleaseDate = Array(releaseDatesList).sorted().last!
        filterParameters.filterLanguage = "All languages"
        filterParameters.areFiltersApplied = false
    }
    
}



