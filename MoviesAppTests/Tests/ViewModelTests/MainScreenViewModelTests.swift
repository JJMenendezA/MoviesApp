//
//  MoviesAppTests.swift
//  MoviesAppMainVieModelTests
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class MainScreenViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchAllMovies_successfullyCompletes() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        // Act
        await sut.fetchMovies()
        XCTAssertFalse(sut.moviesDictionary.isEmpty, "Dictionary shouldn't be empty after fetching")
    }
    
    func test_fetchAllMovies_failsWithError() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        useCase.shouldFail = true
        // Act
        XCTAssertTrue(sut.isInformationLoading, "Loading state should be true before fetch completes")
        await sut.fetchMovies()
        XCTAssertFalse(sut.isInformationLoading, "Loading state should be false after fetch completes")
        XCTAssertTrue(sut.hasErrorBeenTriggered, "HasErrorBeenTriggered state should be true after fetch fails with error")
        XCTAssertEqual(sut.error, AppError.noData)
    }
    
    func test_setDateArray_succcessfullyCompletes() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        // Act
        await sut.fetchMovies()
        sut.setDateArray()
        XCTAssertFalse(sut.releaseDatesArray.isEmpty, "Array shouldn't be empty after fetching")
    }
    
    func test_setDateArray_failsToConclude() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        useCase.shouldFail = true
        // Act
        XCTAssertTrue(sut.isInformationLoading, "Loading state should be true before fetch completes")
        await sut.fetchMovies()
        sut.setDateArray()
        XCTAssertTrue(sut.releaseDatesArray.isEmpty, "Array should be empty after error")
    }
    
    func test_setLanguageArray_successfullyCompletes() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        // Act
        await sut.fetchMovies()
        sut.setLanguageArray()
        XCTAssertFalse(sut.languagesArray.isEmpty, "Array shouldn't be empty after fetching")
    }
    
    func test_setLanguageArray_failsToConclude() async throws {
        // Arrange
        let useCase = MockFetchMoviesUseCase()
        let sut = MainScreenViewModel(fetchMoviesUseCase: useCase)
        useCase.shouldFail = true
        // Act
        await sut.fetchMovies()
        sut.setLanguageArray()
        XCTAssertEqual(sut.languagesArray, ["All languages"], "Array should only have All languages in it")
    }
}
