//
//  DetailsItemComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsItemComponent: View {
    var title: String
    var caption: String
    var body: some View {
        VStack {
            SubtitleComponent(text: NSLocalizedString(title, comment: ""))
            
            Text(caption)
                .font(.body)
                .foregroundStyle(.white)
                .frame(height: 50)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        } // :VStack
        .frame(width: 150)
    }
}

#Preview {
    DetailsItemComponent(title: "Genre", caption: "Horror")
}
