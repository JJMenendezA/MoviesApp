//
//  DetailsImageAndTaglineComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 02/09/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI
import Kingfisher

struct DetailsImageAndTaglineComponent: View {
    var arrayImagePaths: [String?]
    var txtTagline: String
    @State private var imageXScale: CGFloat = 1
    @State private var imageWidth: CGFloat = 300
    @State private var imageHeight: CGFloat = 425
    @State private var activeImage: String = ""
    var body: some View {
        VStack {
            if arrayImagePaths.filter({ $0 != nil }).count > 1 {
                if let moviePosterPath = arrayImagePaths[0],
                   let alternativeImagePath = arrayImagePaths[1],
                   let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
                    Button(action: {
                        withAnimation {
                            if imageXScale < 0 {
                                imageXScale = 1
                                activeImage = moviePosterPath
                                imageWidth = 300
                                imageHeight = 425
                            } else {
                                imageXScale = -1
                                activeImage = alternativeImagePath
                                imageWidth = 375
                                imageHeight = 275
                            }
                        }
                    }, label: {
                        KFImage(movieImageURL.appendingPathComponent(activeImage))
                            .resizable()
                            .frame(width: imageWidth, height: imageHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 10)
                            .padding(.bottom, 20)
                            .scaleEffect(x: imageXScale, y: 1)
                    })
                }
            } else {
                if let moviePosterPath = arrayImagePaths[0],
                   let movieImageURL = URL(string: "https://image.tmdb.org/t/p/w500") {
                    KFImage(movieImageURL.appendingPathComponent(moviePosterPath))
                        .resizable()
                        .frame(width: 300, height: 425)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 10)
                        .padding(.bottom, 20)
                }
            }
            
            Text(txtTagline)
                .italic()
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, txtTagline.isEmpty ? 0 : 20)
                .lineLimit(4)
                .minimumScaleFactor(0.5)
        } // :VStack
        .onAppear {
            if !arrayImagePaths.isEmpty {
                if let moviePosterPath = arrayImagePaths[0] {
                    activeImage = moviePosterPath
                }
            }
        }
    }
}

#Preview {
    DetailsImageAndTaglineComponent(arrayImagePaths: ["/63xYQj1BwRFielxsBDXvHIJyXVm.jpg", "/18TSJF1WLA4CkymvVUcKDBwUJ9F.jpg"], txtTagline: "Example")
}
