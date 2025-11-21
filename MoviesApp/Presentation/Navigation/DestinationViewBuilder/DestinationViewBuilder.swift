//
//  DestinationViewBuilder.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 21/11/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

@ViewBuilder
func destinationViewBuilder(for route: Routes) -> some View {
    switch route {
    case .details(let id):
        DetailsScreenView(movieId: id)
    }
}
