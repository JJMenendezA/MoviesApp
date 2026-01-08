//
//  MainComponentsSubtitle.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 11/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MainComponentsSubtitle: View {
    var title: LocalizedStringResource
    var body: some View {
        SharedComponentsLeadAligned {
            SharedComponentsSubtitle(text: title)
        } // :LeadAlignedView
    }
}

#Preview {
    MainComponentsSubtitle(title: "Now playing")
}
