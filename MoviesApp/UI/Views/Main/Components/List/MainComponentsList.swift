//
//  MainComponentsList.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/01/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct MainComponentsList: View {
    var title: String
    var movies: [MovieEntity]
    var isUpcoming: Bool = false
    var body: some View {
        VStack {
            MainComponentsSubtitle(title: title)
            SharedComponentsList(movies: movies, isUpcoming: isUpcoming)
                .transition(.slide)
        } // :VStack
    }
}

#Preview {
    MainComponentsList(title: "Now playing", movies: [])
}
