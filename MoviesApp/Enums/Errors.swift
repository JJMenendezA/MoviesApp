//
//  Errors.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

enum AppError: Error, LocalizedError {
    case invalidResponse(statusCode: Int)
    case noData
    

    var errorDescription: String {
        switch self {
        case .invalidResponse(let statusCode):
            "Invalid Response \(statusCode)"
        case .noData:
            "No Data"
        }
    }
}
