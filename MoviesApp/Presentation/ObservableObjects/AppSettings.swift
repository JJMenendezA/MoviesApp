//
//  AppSettings.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/01/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

class AppSettings: ObservableObject {
    @Published var isShowingRating: Bool = true
    @Published var selectedLanguage: String = "en"
    
    var locale: Locale {
        Locale(identifier: selectedLanguage)
    }
}
