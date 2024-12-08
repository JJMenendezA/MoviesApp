//
//  DetailsScreenViewModel.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation


class DetailsScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    var similarMoviesList: [MovieInfo] = []
    
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MoviesService()) {
        self.moviesService = moviesService
    }
    
    
    func fetchMovieDetails(movieId: Int) {
        isLoading = true
        moviesService.fetchSimilarMovies(endPoint: MoviePathTypes.similar(movieId: movieId).endpoint, completion: { result in
            switch result {
            case .success(let fetchedMovies):
                self.similarMoviesList = fetchedMovies.results
                self.isLoading =  false
                
            case .failure(let error):
                print(error)
                self.isLoading = false
                
            }
        })
    }
}
