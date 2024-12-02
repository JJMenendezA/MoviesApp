//
//  NoMoviesComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/11/24.
//

import SwiftUI

struct NoMoviesComponent: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("🤷‍♀️")
                .font(.system(size: 100))
            
            Text("I'm sorry, but no movies were found.")
                .foregroundStyle(.red600)
                .fontWeight(.bold)
                .font(.title)
                .padding(.bottom, 10)
            
            Text("You can try searching for a different movie.")
                .foregroundStyle(.white.opacity(0.8))
                .font(.callout)
        } // :VStack
        .padding(.horizontal, 25)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    NoMoviesComponent()
}
