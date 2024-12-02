//
//  SplashScreenView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image("ClapperBoardIcon")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray900)
       
    }
}

#Preview {
    SplashScreenView()
}
