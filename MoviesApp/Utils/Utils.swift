//
//  LinearGradientUtils.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 06/11/24.
//

import SwiftUI

// Reusable linear gradient component
func customLinearGradient(colors: [Color]) -> LinearGradient {
    return LinearGradient(colors: colors, startPoint: .bottomLeading, endPoint: .topTrailing)
}
