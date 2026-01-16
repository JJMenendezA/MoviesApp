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
    @StateObject private var appSettings: AppSettings = AppSettings()
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showSplash = false
                        }
                    }
            } else {
                NavigationStack(path: $router.path) {
                    MainView(service: MoviesServiceImpl(language: $appSettings.selectedLanguage))
                        .statusBar(hidden: true)
                        .navigationDestination(for: Routes.self,
                                               destination: { route in
                            destinationViewBuilder(for: route, language: $appSettings.selectedLanguage)
                        })
                } // :NavigationStack
                .environmentObject(router)
                .environmentObject(appSettings)
                .environment(\.locale, appSettings.locale) 
            }
        }
    }
}
