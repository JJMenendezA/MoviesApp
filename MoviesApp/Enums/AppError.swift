//
//  Errors.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

public enum AppError: Error, LocalizedError, Equatable {
    case invalidResponse(statusCode: Int)
    case noData
    case decodingError
    case unknown(localizedDesciption: String)

    var localizedDescription: String {
        switch self {
        case .invalidResponse(let statusCode):
            "There was an invalid response: \(statusCode)."
        case .noData:
            "There is no data."
        case .decodingError:
            "The data couldn’t be read because it is missing or has invalid formatting."
        case .unknown(let localizedDesciption):
            localizedDesciption
        }
    }
}
