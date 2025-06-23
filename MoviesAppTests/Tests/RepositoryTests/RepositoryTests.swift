//
//  RepositoryTests.swift
//  MoviesAppTests
//
//  Created by Juan José Menéndez Alarcón on 13/06/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class RepositoryTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchMovies_successfullyCompletes() async throws {
        // Arrange
        let mockService = MockMoviesService()
        let sut: MoviesRepository = MoviesRepositoryImpl(moviesService: mockService)
        do {
            let fetchedMovies = try await sut.fetchMovies()
            XCTAssertFalse(fetchedMovies.isEmpty, "Response shouldn't be empty!")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_fetchMovies_failsWithError() async throws {
        // Arrange
        let mockService = MockMoviesService()
        let sut: MoviesRepository = MoviesRepositoryImpl(moviesService: mockService)
        mockService.shouldFail = true
        // Act
        do {
            _ = try await sut.fetchMovies()
            XCTFail("Fetching should be failing!")
        } catch let error as AppError {
            XCTAssertEqual(error, AppError.noData)
        } catch {
            XCTFail("Expected AppError.noData but got \(error).")
        }
    }
    
    func test_fetchDetails_successfullyCompletes() async throws {
        // Arrange
        let mockService = MockMoviesService()
        let sut: MoviesRepository = MoviesRepositoryImpl(moviesService: mockService)
        // Act
        do {
            let fetchedDetails = try await sut.fetchDetails(endPoint: "")
            XCTAssertEqual(fetchedDetails, dummyDetailsMovieInfo)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_fetchDetails_failsWithError() async throws {
        // Arrange
        let mockService = MockMoviesService()
        let sut: MoviesRepository = MoviesRepositoryImpl(moviesService: mockService)
        mockService.shouldFail = true
        // Act
        do {
            _ = try await sut.fetchDetails(endPoint: "")
            XCTFail("Fetching should be failing!")
        } catch let error as AppError {
            XCTAssertEqual(error, AppError.noData)
        } catch {
            XCTFail("Expected AppError.noData but got \(error).")
        }
    }
}
