//
//  MainScreenObjects.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 20/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

class FilterParameters: ObservableObject {
    @Published var filterLanguage: String = ""
    @Published var areFiltersApplied: Bool = false
    @Published var languageList: [String] = []
}
