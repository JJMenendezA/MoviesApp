//
//  DetailsRowComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsRowComponent<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        HStack(alignment: .center) {
            content
        } // :HStack
        .padding(.bottom, 20)
    }
}
