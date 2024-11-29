//
//  TextAlignedLeadingComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 06/11/24.
//

import SwiftUI

struct TextAlignedLeadingComponent: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
              
            Spacer()
        } // :HStack
        .padding(.horizontal)
    }
}

#Preview {
    TextAlignedLeadingComponent(text: "Hello World!")
}
