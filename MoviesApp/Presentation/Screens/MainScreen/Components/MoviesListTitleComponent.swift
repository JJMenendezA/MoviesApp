//
//  MoviesListTitleComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 11/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MoviesListTitleComponent: View {
    var title: String
    var body: some View {
        LeadAlignedView {
            SubtitleComponent(text: NSLocalizedString(title, comment: ""))
        } // :LeadAlignedView
    }
}

#Preview {
    MoviesListTitleComponent(title: "Now playing")
}
