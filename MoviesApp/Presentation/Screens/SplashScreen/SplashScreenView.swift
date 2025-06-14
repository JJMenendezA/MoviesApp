//
//  SplashScreenView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isAnimated: Bool = false
    var body: some View {
        VStack {
            Image("ClapperBoardIcon")
                .resizable()
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isAnimated ? 360 : 0))
                .animation(.easeInOut(duration: 1), value: isAnimated)
            
            Text("Movies App")
                .fontWeight(.bold)
                .font(.title)
                .foregroundStyle(.white)
                .padding()
                .opacity(isAnimated ? 1 : 0)
                .animation(.easeInOut(duration: 1), value: isAnimated)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
        .onAppear {
            isAnimated.toggle()
        }
        
    }
}

#Preview {
    SplashScreenView()
}
