//
//  MainMoviesListTitleComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 11/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MainMoviesListTitleComponent: View {
    var title: String
    var body: some View {
        SharedLeadAlignedComponent {
            SharedSubtitleComponent(text: NSLocalizedString(title, comment: ""))
        } // :LeadAlignedView
    }
}

#Preview {
    MainMoviesListTitleComponent(title: "Now playing")
}
