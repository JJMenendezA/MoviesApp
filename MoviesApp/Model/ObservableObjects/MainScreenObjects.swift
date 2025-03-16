//
//  MainScreenObjects.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 20/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

class FilterParameters: ObservableObject {
    private var filterOriginalLanguage: String = "All languages"
    private var filterOriginalStartReleaseDate: Date = Date()
    private var filterOriginalEndReleaseDate: Date = Date()
    
    @Published var filterLanguage: String = "All languages"
    @Published var filterStartReleaseDate: Date = Date()
    @Published var filterEndReleaseDate: Date = Date()
    
    var areFiltersApplied: Bool {
        filterLanguage != filterOriginalLanguage || filterStartReleaseDate != filterOriginalStartReleaseDate || filterEndReleaseDate != filterOriginalEndReleaseDate
        }
    
    func setDefaultValues(startDate: Date, endDate: Date) {
        filterStartReleaseDate = startDate
        filterOriginalStartReleaseDate = startDate
        filterEndReleaseDate = endDate
        filterOriginalEndReleaseDate = endDate
    }
    
    func cleanFilters() {
        filterLanguage = filterOriginalLanguage
        filterStartReleaseDate = filterOriginalStartReleaseDate
        filterEndReleaseDate = filterOriginalEndReleaseDate
    }
}
