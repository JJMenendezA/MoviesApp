//
//  DetailsScreenTitleComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 16/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsScreenTitleComponent: View {
    var text: String
    var maxWidth: CGFloat = 150
    var body: some View {
        Text(text)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .frame(maxWidth: maxWidth, maxHeight: 40)
            .multilineTextAlignment(.center)
            .background(customLinearGradient(colors: [.gray900, .black]).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
