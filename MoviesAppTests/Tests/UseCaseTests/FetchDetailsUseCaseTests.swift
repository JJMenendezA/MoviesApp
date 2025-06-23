//
//  FetchDetailsUseCaseTests.swift
//  MoviesAppTests
//
//  Created by Juan José Menéndez Alarcón on 22/06/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import XCTest
@testable import MoviesApp

final class FetchDetailsUseCaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchDetailsUseCase_successfullyCompletes() async throws {
        // Arrange
        let repository = MockMoviesRepository()
        let sut: FetchMovieDetailsUseCase = FetchMovieDetailsImpl(repository: repository)
        // Act
            do {
                let fetchedDetails = try await sut.fetch(endPoint: "")
                XCTAssertEqual(fetchedDetails, dummyDetailsMovieInfo)
            } catch {
                XCTFail(error.localizedDescription)
            }
    }
    
    func test_fetchDetailsUseCase_failsWithError() async throws {
        // Arrange
        let repository = MockMoviesRepository()
        let sut: FetchMovieDetailsUseCase = FetchMovieDetailsImpl(repository: repository)
        repository.shouldFail = true
        // Act
        do {
            _ = try await sut.fetch(endPoint: "")
            XCTFail("Fetching should be failing!")
        } catch let error as AppError {
            XCTAssertEqual(error, AppError.noData)
        } catch {
            XCTFail("Expected AppError.noData but got \(error).")
        }
    }
}
