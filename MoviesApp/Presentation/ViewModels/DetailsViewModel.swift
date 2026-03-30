//
//  DetailsViewModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var hasErrorTriggered: Bool = false
    @Published var error: AppError?
    
    var movieDetails: MovieDetailsEntity?
    
    private let fetchMovieDetailsUseCase: FetchMovieDetailsUseCase
    
    init(fetchMovieDetailsUseCase: FetchMovieDetailsUseCase) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    }
    
    @MainActor
    func fetchMovieDetails(movieId: Int) async {
        isLoading = true
        do {
            movieDetails = try await fetchMovieDetailsUseCase.fetch(endPoint: MoviePathTypes.details(movieId: movieId).endpoint)
            isLoading = false
        } catch let error as AppError {
            self.error = error
            hasErrorTriggered = true
            isLoading = false
        } catch {
            self.error = AppError.unknown(localizedDesciption: error.localizedDescription)
            hasErrorTriggered = true
            isLoading = false
        }
    }
}
