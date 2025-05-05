//
//  DetailsScreenViewModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation
import SwiftUI

class DetailsScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var hasErrorTrigerred: Bool = false
    @Published var error: AppError?
    
    var movieDetails: MovieDetailsEntity?
    
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MoviesService()) {
        self.moviesService = moviesService
    }
    
    @MainActor
    func fetchMovieDetails(movieId: Int) async {
        isLoading = true
        Task {
            do {
                movieDetails = try await MovieDetailsEntity(from:
                                                                moviesService.fecthMovieDetails(endPoint:
                                                                                                MoviePathTypes.details(movieId: movieId).endpoint))
                isLoading = false
            } catch {
                self.error = AppError.unknown(localizedDesciption: error.localizedDescription)
                hasErrorTrigerred = true
                isLoading = false
            }
        }
    }
}
