//
//  DetailsComponentsStars.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsComponentsStars: View {
    var stars: Int
    var hasHalfStar: Bool
    var body: some View {
        HStack {
            if stars > 0 {
                ForEach(0..<stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .frame(height: 50)
                }
                
                if hasHalfStar {
                    Image(systemName: "star.leadinghalf.filled")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .frame(height: 50)
                }
            } else {
                Text("No rating available.")
                    .font(.body)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 150, maxHeight: 40)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(height: 50)
            }
        } // :HStack
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
    }
}

#Preview {
    DetailsComponentsStars(stars: 2, hasHalfStar: true)
}
