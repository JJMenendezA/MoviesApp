//
//  MoviesService.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 24/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

class MoviesService: MoviesServiceProtocol {
    private let networkManager: NetworkManager
    private let language: String = NSLocale.current.language.languageCode?.identifier ?? "en-US"
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
        
    func fetchAllMovies(completion: @escaping (Result<[String: MoviesResponse], AppError>) -> Void) {
        var moviesList: [String: MoviesResponse] = [:]
        var moviesError: AppError?
        
        let dispatchGroup = DispatchGroup()
        
        for type in MovieTypes.allCases {
            dispatchGroup.enter()
            fetchMovies(endpoint: type.endpoint, completion: { result in
                switch result {
                case .success(let fetchedMovies):
                    moviesList[type.title] = fetchedMovies
                case .failure(let error):
                    moviesError = error
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            if moviesError == nil {
                completion(.success(moviesList))
            } else {
                if let error = moviesError {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchMovies(endpoint: String,
                     completion: @escaping (Result<MoviesResponse, AppError>) -> Void) {
        networkManager.getMoviesRequest(endpoint: endpoint,
                                        queryItems: [URLQueryItem(name: "language",
                                                                  value: language),
                                                     URLQueryItem(name: "page",
                                                                  value: "1")],
                                        response: MoviesResponse.self) { result in
            switch result {
            case .success(let fetchedMovies):
                DispatchQueue.main.async {
                    completion(.success(fetchedMovies))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchMovieDetails(endPoint: String,
                           completion: @escaping (Result<MovieDetailsResponse, AppError>) -> Void) {
        networkManager.getMoviesRequest(endpoint: endPoint,
                                        queryItems: [URLQueryItem(name: "append_to_response",
                                                                  value: "videos,similar"),
                                                     URLQueryItem(name: "language",
                                                                  value: language)],
                                        response: MovieDetailsResponse.self) { result in
            switch result {
            case .success(let fetchedMovies):
                DispatchQueue.main.async {
                    completion(.success(fetchedMovies))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
