//
//  MainViewModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 18/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    private var moviesDictionary: [String: MoviesEntity] = [:]
    @Published var mutableMoviesDictionary: [String: MoviesEntity] = [:]
    var randomMovie: MovieEntity?
    
    @Published var error: AppError?
    @Published var hasErrorBeenTriggered: Bool = false
    @Published var hasToastBeenTriggered: Bool = false
    
    @Published var isInformationLoading: Bool = true
    @Published var hasInformationLoaded: Bool = false
    @Published var languagesArray: [String] = []
    @Published var releaseDatesArray: [Date] = []
    @Published var filterParameters: FilterParameters = FilterParameters()
    
    private let fetchMoviesUseCase: FetchMoviesUseCase
    private let fetchMovieUseCase: FetchMovieDetailsUseCase
    private let createLanguageArrayUseCase: CreateLanguageArrayUseCase
    private let createDateArrayUseCase: CreateDateArrayUseCase
    private let filterMoviesByDateUseCase: FilterMoviesByDateUseCase
    init(fetchMoviesUseCase: FetchMoviesUseCase,
         fetchMovieUseCase: FetchMovieDetailsUseCase,
         createLanguageArrayUseCase: CreateLanguageArrayUseCase,
         createDateArrayUseCase: CreateDateArrayUseCase,
         filterMoviesByDateUseCase: FilterMoviesByDateUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.fetchMovieUseCase = fetchMovieUseCase
        self.createLanguageArrayUseCase = createLanguageArrayUseCase
        self.createDateArrayUseCase = createDateArrayUseCase
        self.filterMoviesByDateUseCase = filterMoviesByDateUseCase
    }
    
    @MainActor
    func fetchMovies(hasLanguageChanged: Bool = false) async {
        isInformationLoading = true
        do {
            moviesDictionary = try await fetchMoviesUseCase.fetch()
            if !hasLanguageChanged {
                setRandomMovie()
            } else {
                if let movie = randomMovie {
                    await getRandomMovieTranslated(movieId: movie.id)
                }
            }
            setMutableMoviesDictionaryToDefaultValues()
            setDateArray()
            setLanguageArray()
            setDefaultDateVariables()
            isInformationLoading = false
            hasInformationLoaded = true
            if hasLanguageChanged {
                hasToastBeenTriggered = true
            }
        } catch let error as AppError {
            triggerErrorAlert(appError: error)
        } catch {
            triggerErrorAlert(appError:
                                AppError.unknown(localizedDesciption: error.localizedDescription))
        }
    }
    
    private func setRandomMovie() {
        if  let randomList = self.moviesDictionary.values.randomElement(),
            let randomMovie = randomList.moviesArray.randomElement() {
            self.randomMovie = randomMovie
        }
    }
    
    private func getRandomMovieTranslated(movieId: Int) async {
        do {
            let movieTranslated = try await fetchMovieUseCase.fetch(endPoint: MoviePathTypes.details(movieId: movieId).endpoint)
            randomMovie = MovieEntity(from: movieTranslated)
        } catch let error as AppError {
            triggerErrorAlert(appError: error)
        } catch {
            triggerErrorAlert(appError:
                                AppError.unknown(localizedDesciption: error.localizedDescription))
        }
    }
    
    func setMutableMoviesDictionaryToDefaultValues() {
        mutableMoviesDictionary = moviesDictionary
    }
    
    func setLanguageArray() {
        languagesArray = createLanguageArrayUseCase.create(moviesDictionary: moviesDictionary)
    }
    
    func setDateArray() {
        releaseDatesArray = createDateArrayUseCase.create(moviesDictionary: moviesDictionary)
    }
    
    func setDefaultDateVariables() {
        if let startDate = releaseDatesArray.sorted().first,
           let endDate = releaseDatesArray.sorted().last {
            filterParameters.setDefaultValues(startDate: startDate, endDate: endDate)
        }
    }
    
    func searchMoviesByTitle(title: String) {
        guard !title.isEmpty else {
            setMutableMoviesDictionaryToDefaultValues()
            return
        }
        
        moviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                movie.title.localizedCaseInsensitiveContains(title)
            })
        })
    }
    
    private func filterMoviesByLanguage() {
        mutableMoviesDictionary.forEach({ movie in
            mutableMoviesDictionary[movie.key]?.moviesArray = movie.value.moviesArray.filter({ movie in
                movie.originalLanguage == filterParameters.language
            })
        })
    }
    
    func filterMovies() {
        setMutableMoviesDictionaryToDefaultValues()
        
        guard filterParameters.areFiltersApplied else { return }
        
        if filterParameters.language != "All languages" {
            filterMoviesByLanguage()
        }
        
        if let firstDate = releaseDatesArray.first,
           let lastDate = releaseDatesArray.last {
            if filterParameters.startDate != firstDate ||
                filterParameters.endDate != lastDate {
                mutableMoviesDictionary = filterMoviesByDateUseCase.filter(moviesDictionary: mutableMoviesDictionary,
                                                                           startDate: filterParameters.startDate,
                                                                           endDate: filterParameters.endDate)
            }
        }
    }
    
    private func triggerErrorAlert(appError: AppError) {
        error = appError
        hasErrorBeenTriggered = true
        isInformationLoading = false
    }
}
