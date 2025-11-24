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
    @StateObject private var router: Router = Router()
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSplash = false
                        }
                    }
            } else {
                NavigationStack(path: $router.path) {
                    MainScreenView()
                        .statusBar(hidden: true)
                        .navigationDestination(for: Routes.self,
                                               destination: { route in
                            destinationViewBuilder(for: route)
                        })
                } // :NavigationStack
                .environmentObject(router)
            }
        }
    }
}
