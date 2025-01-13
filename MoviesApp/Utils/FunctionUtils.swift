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

// Date related functions
func getTodaysDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: Date())
}

func getTwoWeeksAgoDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let twoWeeksAgoDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: Date())!
    return dateFormatter.string(from: twoWeeksAgoDate)
}
