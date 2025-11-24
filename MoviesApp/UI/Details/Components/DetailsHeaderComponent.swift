//
//  DetailsHeaderComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct DetailsHeaderComponent: View {
    var title: String
    var action: () -> Void
    var closeAction: (() -> Void)?
    var body: some View {
        ZStack {
            HStack {
                Button(action: { action() },
                       label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                })
                .padding(.leading)
                
                Spacer()
                
                if let close = closeAction {
                    Button(action: { close() },
                           label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    })
                    .padding(.trailing)
                }
            } // :HStack
            
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
    DetailsHeaderComponent(title: "Example", action: {})
}
