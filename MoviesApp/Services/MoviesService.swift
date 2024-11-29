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
        
        dispatchGroup.enter()
        fetchMovies(endpoint: EndpointsMovies.popular, completion: { result in
            switch result {
            case .success(let fetchedMovies):
                moviesList["popular"] = fetchedMovies
            case .failure(let error):
                moviesError = error
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        fetchMovies(endpoint: EndpointsMovies.nowPlaying, completion: { result in
            switch result {
            case .success(let fetchedMovies):
                moviesList["nowPlaying"] = fetchedMovies
            case .failure(let error):
                moviesError = error
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        fetchMovies(endpoint: EndpointsMovies.upcoming, completion: { result in
            switch result {
            case .success(let fetchedMovies):
                moviesList["upcoming"] = fetchedMovies
            case .failure(let error):
                moviesError = error
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        fetchMovies(endpoint: EndpointsMovies.topRated, completion: { result in
            switch result {
            case .success(let fetchedMovies):
                moviesList["topRated"] = fetchedMovies
            case .failure(let error):
                moviesError = error
            }
            dispatchGroup.leave()
        })
        
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
