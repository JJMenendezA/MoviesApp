//
//  LeadAlignedView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 16/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct LeadAlignedView<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        HStack {
            content
            Spacer()
        } // :HStack
        .padding(.horizontal)
    }
}
