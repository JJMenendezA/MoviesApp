//
//  DetailsScreenHeaderComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsScreenHeaderComponent: View {
    var title: String
    var action: () -> Void
    var body: some View {
        ZStack(alignment: .leading) {
            Button(action: {
                action()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            })
            .padding(.leading)
            
            HStack {
                Spacer()
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: 300)
                Spacer()
            } // :HStack
        } // :ZStack
        .padding(.bottom)
        .background(.black)
        .shadow(color: .black, radius: 10)
    }
}

#Preview {
    DetailsScreenHeaderComponent(title: "Example", action: {})
}
