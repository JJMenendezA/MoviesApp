//
//  DetailsComponentsItem.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsComponentsItem: View {
    var title: LocalizedStringResource
    var caption: LocalizedStringResource
    var body: some View {
        VStack {
            SharedComponentsSubtitle(text: title)
            
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
    DetailsComponentsItem(title: "Genre", caption: "Horror")
}
