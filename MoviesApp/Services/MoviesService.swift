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
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
        
    func fetchAllMovies(completion: @escaping (Result<[String : Movies], Error>) -> Void) {
        var moviesList: [String : Movies] = [:]
        var moviesError: Error?
        
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
                completion(.failure(moviesError!))
            }
        }
    }
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, any Error>) -> Void) {
        networkManager.getRequest(endpoint: endpoint, response: Movies.self) { result in
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
