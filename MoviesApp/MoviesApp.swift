//
//  MoviesApp.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 21/10/24.
//

import SwiftUI

@main
struct MoviesApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showSplash = false
                        }
                    }
            } else {
                MainScreenView() // Replace with your main SwiftUI view
            }
        }
    }
}
