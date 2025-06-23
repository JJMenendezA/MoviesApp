//
//  MoviesAppUseCaseTest.swift
//  MoviesAppTests
//
//  Created by Juan José Menéndez Alarcón on 22/06/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class FetchMoviesUseCaseTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchMoviesUseCase_successfullyCompletes() async throws {
        // Arrange
        let repository = MockMoviesRepository()
        let sut: FetchMoviesUseCase = FetchMoviesUseCaseImpl(repository: repository)
        // Act
        do {
            let fetchedMovies = try await sut.fetch()
            XCTAssertFalse(fetchedMovies.isEmpty, "Response shouldn't be empty!")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_fetchMoviesUseCase_failsWithError() async throws {
        // Arrange
        let repository = MockMoviesRepository()
        let sut: FetchMoviesUseCase = FetchMoviesUseCaseImpl(repository: repository)
        repository.shouldFail = true
        // Act
        do {
            _ = try await sut.fetch()
            XCTFail("Fetching should be failing!")
        } catch let error as AppError {
            XCTAssertEqual(error, AppError.noData)
        } catch {
            XCTFail("Expected AppError.noData but got \(error).")
        }
    }
}
