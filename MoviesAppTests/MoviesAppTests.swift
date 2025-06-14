//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Juan José Menéndez Alarcón on 21/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class MoviesAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchAllMovies_successfullyCompletes() throws {
        // Arrange
        let sut = MockMoviesService()
        
        let expectation = self.expectation(description: "Fetch all movies complete")
        
        // Act
        Task {
            do {
                let fetchedMovies = try await sut.fetchAllMovies()
                XCTAssertFalse(fetchedMovies.isEmpty, "Loading state should be false after fetching completes")
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchAllMovies_failsWithError() throws {
        // Arrange
        let sut = MockMoviesService()
        
        sut.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch all movies fails")
        
        // Act
        Task {
            do {
                _ = try await sut.fetchAllMovies()
                XCTFail("Test should be failing!")
            } catch let error as AppError {
                XCTAssertEqual(error, AppError.noData)
                expectation.fulfill()
            } catch {
                XCTFail("Expected AppError.noData but got \(error).")
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchMovies_successfullyCompletes() throws {
        // Arrange
        let sut = MockMoviesService()
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        Task {
            do {
                let fetchedMovies = try await sut.fetchMovies(endpoint: "/popular")
                XCTAssertNotNil(fetchedMovies)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }

    func test_fetchMovies_failsWithError() throws {
        // Arrange
        let sut = MockMoviesService()
        
        sut.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        Task {
            do {
                _ = try await sut.fetchMovies(endpoint: "/popular")
                XCTFail("Test should be failing!")
            } catch let error as AppError {
                XCTAssertEqual(error, AppError.noData)
                expectation.fulfill()
            } catch {
                XCTFail("Expected AppError.noData but got \(error).")
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchMovieDetails_successfullyCompletes() throws {
        // Arrange
        let sut = MockMoviesService()
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        Task {
            do {
                let fetchedDetails = try await sut.fecthMovieDetails(endPoint: "/details")
                XCTAssertNotNil(fetchedDetails)
                expectation.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchMovieDetails_failsWithError() throws {
        // Arrange
        let sut = MockMoviesService()
        
        sut.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        Task {
            do {
                _ = try await sut.fecthMovieDetails(endPoint: "/details")
                XCTFail("Test should be failing!")
            } catch let error as AppError {
                XCTAssertEqual(error, AppError.noData)
                expectation.fulfill()
            } catch {
                XCTFail("Expected AppError.noData but got \(error).")
            }
        }
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
}
