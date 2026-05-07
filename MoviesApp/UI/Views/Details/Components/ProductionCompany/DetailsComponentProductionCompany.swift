//
//  DetailsComponentProductionCompany.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 06/05/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailsComponentProductionCompany: View {
    @Binding var productionCompanyName: String
    @Binding var hasToastBeenTriggered: Bool
    var productionCompany: ProductionCompanyEntity
    var action: () -> Void
    var body: some View {
        if let logoPath = productionCompany.logoPath,
           let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
            Button(action: {
                if !hasToastBeenTriggered {
                    productionCompanyName = productionCompany.name
                    withAnimation {
                        hasToastBeenTriggered = true
                    }
                } else {
                    if productionCompanyName != productionCompany.name {
                        productionCompanyName = productionCompany.name
                        action()
                    }
                }
            }, label: {
                KFImage(movieImageURL.appendingPathComponent(logoPath))
                    .resizable()
                    .frame(width: 100, height: 50)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(customLinearGradient(colors: [.black, .white]).opacity(0.5))
                    }
            })
        } else {
            VStack {
                Text(productionCompany.name)
                    .minimumScaleFactor(0.2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            } // :VStack
            .frame(width: 100, height: 50)
            .foregroundStyle(.black)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(customLinearGradient(colors: [.black, .white]).opacity(0.5))
            }
        }
    }
}

#Preview {
    DetailsComponentProductionCompany(productionCompanyName: .constant(""),
                                      hasToastBeenTriggered: .constant(false),
                                      productionCompany: ProductionCompanyEntity(name: "", logoPath: "", country: ""),
                                      action: {})
}
