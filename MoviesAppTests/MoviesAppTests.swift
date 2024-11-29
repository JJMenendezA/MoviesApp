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
        sut.fetchAllMovies(completion: { result in
            switch result {
            case .success(let loadingState):
                // Assert
                //XCTAssertFalse(loadingState, "Loading state should be false after fetching completes")
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        })
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchAllMovies_failsWithError() throws {
        // Arrange
        let sut = MockMoviesService()
        
        sut.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch all movies fails")
        
        // Act
        sut.fetchAllMovies(completion: { result in
            switch result {
            case .success:
                // Assert
                XCTFail("Test should be failing!")
            case .failure(let error):
                //XCTAssertEqual(error.localizedDescription, AppError.failedToFetchMovies.localizedDescription)
                expectation.fulfill()
            }
        })
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
    
    func test_fetchMovies_successfullyCompletes() throws {
        // Arrange
        let sut = MockMoviesService()
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        sut.fetchMovies(endpoint: "/popular", completion: { result in
            switch result {
            case .success(let movies):
                // Assert
                XCTAssertNotNil(movies)
                expectation.fulfill()
                
            case .failure:
                XCTFail("Test should be successful!")
            }
        })
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }

    
    func test_fetchMovies_failsWithError() throws {
        // Arrange
        let sut = MockMoviesService()
        
        sut.shouldFail = true
        
        let expectation = self.expectation(description: "Fetch movies complete")
        
        // Act
        sut.fetchMovies(endpoint: "/popular", completion: { result in
            switch result {
            case .success:
                // Assert
                XCTFail("Test should be failing!")
                
            case .failure(let error):
                //XCTAssertEqual(error.localizedDescription, AppError.failedToFetchMovies.localizedDescription)
                expectation.fulfill()
            }
        })
        
        // Wait for completion
        waitForExpectations(timeout: 5)
    }
}
