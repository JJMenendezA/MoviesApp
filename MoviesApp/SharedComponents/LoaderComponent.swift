//
//  LoaderComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/12/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct LoaderComponent: View {
    var body: some View {
        ZStack {
            ProgressView {
                HStack{
                    Spacer()
                    Image(systemName: "hand.raised")
                    Text("Please wait...")
                    Spacer()
                } // :HStack
                .foregroundStyle(.white)
            } // :ProgressView
            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            .background(.clear)
            .controlSize(.large)
            .fontWeight(.bold)
        
        } // :ZStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.7))
    }
}

#Preview {
    LoaderComponent()
}
