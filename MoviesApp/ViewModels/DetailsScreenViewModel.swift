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
    @Published var hasErrorTrigerred: Bool = false
    @Published var error: AppError?
    
    var movieDetails: MovieDetails?
    var similarMoviesList: [MovieInfo] = []
    var movieVideo: URL?
    
    private let moviesService: MoviesService
    
    init(moviesService: MoviesService = MoviesService()) {
        self.moviesService = moviesService
    }
    
    
    func fetchMovieDetails(movieId: Int) {
        isLoading = true
        moviesService.fetchMovieDetails(endPoint: MoviePathTypes.details(movieId: movieId).endpoint, completion: { result in
            switch result {
            case .success(let movieDetails):
                self.movieDetails = movieDetails
                self.similarMoviesList = movieDetails.similar.results
                if let youtubeKey = movieDetails.videos.results.first?.key {
                    self.movieVideo = movieVideoURL.appendingPathComponent(youtubeKey)
                }
                self.isLoading =  false
                
            case .failure(let error):
                self.error = error
                self.hasErrorTrigerred = true
                self.isLoading = false
                
            }
        })
    }
}
