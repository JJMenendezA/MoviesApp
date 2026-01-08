//
//  FilterParameters.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/01/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

class FilterParameters: ObservableObject {
    private var defaultLanguage: String = NSLocalizedString("All languages", comment: "")
    private var defaultStartDate: Date = Date()
    private var defaultEndDate: Date = Date()
    
    @Published var language: String = NSLocalizedString("All languages", comment: "")
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    var areFiltersApplied: Bool {
        language != defaultLanguage ||
        startDate != defaultStartDate ||
        endDate != defaultEndDate
        }
    
    func setDefaultValues(startDate: Date, endDate: Date) {
        self.startDate = startDate
        defaultStartDate = startDate
        self.endDate = endDate
        defaultEndDate = endDate
    }
    
    func cleanFilters() {
        language = defaultLanguage
        startDate = defaultStartDate
        endDate = defaultEndDate
    }
}
