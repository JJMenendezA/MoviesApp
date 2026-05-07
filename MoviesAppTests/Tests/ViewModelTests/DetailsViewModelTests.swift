//
//  DetailsViewModelTests.swift
//  MoviesAppTests
//
//  Created by Juan José Menéndez Alarcón on 22/06/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class DetailsViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchDetails_successfullyCompletes() async throws {
        // Arrange
        let useCase = MockFetchMovieDetailsUseCase()
        let sut = DetailsViewModel(fetchMovieDetailsUseCase: useCase)
        // Act
        await sut.fetchMovieDetails(movieId: 0)
        XCTAssertFalse(sut.isLoading, "Loading state should be false")
        XCTAssertFalse(sut.movieDetails == nil, "MovieDetails shouldn't be nil")
    }
    
    func test_fetchDetails_failsWithError() async throws {
        // Arrange
        let useCase = MockFetchMovieDetailsUseCase()
        let sut = DetailsViewModel(fetchMovieDetailsUseCase: useCase)
        useCase.shouldFail = true
        // Act
        await sut.fetchMovieDetails(movieId: 0)
        XCTAssertFalse(sut.isLoading, "Loading state should be false after fetch completes")
        XCTAssertTrue(sut.hasErrorTriggered, "HasErrorTriggered state should be true after fetch fails with error")
        XCTAssertEqual(sut.error, AppError.noData)
    }
}
