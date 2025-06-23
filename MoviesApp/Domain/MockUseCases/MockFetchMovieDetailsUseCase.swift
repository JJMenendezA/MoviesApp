//
//  MockFetchMovieDetailsUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 26/05/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
    var shouldFail: Bool = false
    
    func fetch(endPoint: String) async throws -> MovieDetailsResponse {
        if shouldFail {
            throw AppError.noData
        } else {
            return dummyDetailsMovieInfo
        }
    }
}
