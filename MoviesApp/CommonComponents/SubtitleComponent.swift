//
//  SubtitleComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI

struct SubtitleComponent: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .font(.callout)
                .fontWeight(.light)
                .padding(.horizontal, 5)
                .foregroundStyle(.white)
                .padding(10)
                .background(.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        } // :HStack
        .padding(10)
    }
}

#Preview {
    SubtitleComponent(text: "Estrenos")
        .background(.black)
}
