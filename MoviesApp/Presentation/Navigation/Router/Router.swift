//
//  Router.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

class Router: ObservableObject {
    @Published var path: [Routes] = []
    
    func navigateTo(_ route: Routes) {
        path.append(route as Routes)
    }
    
    func navigateBackToRoot() {
        path.removeAll()
    }
}
