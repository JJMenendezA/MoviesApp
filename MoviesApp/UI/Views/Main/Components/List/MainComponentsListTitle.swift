//
//  MainComponentsListTitle.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 11/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MainComponentsListTitle: View {
    var title: String
    var body: some View {
        SharedComponentsLeadAligned {
            SharedComponentsSubtitle(text: NSLocalizedString(title, comment: ""))
        } // :LeadAlignedView
    }
}

#Preview {
    MainComponentsListTitle(title: "Now playing")
}
