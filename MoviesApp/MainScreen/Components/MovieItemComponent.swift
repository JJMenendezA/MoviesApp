//
//  MovieItem.swift
//  Movies App
//
//  Created by Juan José Menéndez Alarcón on 27/10/24.
//

import SwiftUI
import Kingfisher

struct MovieItemComponent: View {
    var movie: MovieInfo
    var isUpcoming: Bool = false
    var isTopRated: Bool = false
    @State var date: String?
    // Computed property
    var iconColor: Color {
        if movie.stars >= 4 {
            .green
        } else {
            .red
        }
    }
    var isIconVisible: Bool {
        if (movie.stars <= 2 || movie.stars >= 4) && (!isUpcoming && !isTopRated) {
            true
        } else {
            false
        }
    }
    var body: some View {
        // MARK: - Movie Item
        Button(action: {}){
            ZStack {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)"))
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        // Gradient for the image
                        RoundedRectangle(cornerRadius: 10)
                            .fill(LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top))
                    }
                
                VStack {
                    if isIconVisible {
                        HStack {
                            Spacer()
                            Image(systemName: "popcorn.circle.fill")
                                .resizable()
                                .shadow(radius: 0.75)
                                .frame(width: 25, height: 25)
                                .foregroundStyle(iconColor)
                                .background(.white)
                                .clipShape(Circle())
                                
                            
                        } // :HStack
                        .padding(.trailing, 5)
                        .padding(.top, 5)
                    }
                    
                    Spacer()
                    Text(movie.title)
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4)
                        .font(.body)
                        .frame(height: 40)
                        .padding(.horizontal, 5)
                        .padding(.bottom, isTopRated ? 35 : 20)
                } // :VStack
                
                if isTopRated {
                    
                    HStack {
                        ForEach (0..<movie.stars, id: \.self) { index in
                            Image(systemName: "star.fill")
                        }
                        
                        if movie.hasHalfStar {
                            Image(systemName: "star.leadinghalf.filled")
                        }
                    }
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.4)
                    .frame(width: 145, height: 20)
                    .font(Font.system(size: 15))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
                    .background(customLinearGradient(colors: [.pink700, .pink900]))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .offset(y: 130)
                }
                
                if isUpcoming {
                    Text(date ?? "")
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.4)
                        .frame(width: 75, height: 10)
                        .font(Font.system(size: 15))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                        .background(customLinearGradient(colors: [.purple700, .purple900]))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: 85)
                }
                
            } // :ZStack
            
        } // :Button
        .frame(width: isTopRated ? 175 : 115, height: isTopRated ? 250 : 165)
        .onAppear {
            if isUpcoming {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                let dateFormatted = dateFormatter.date(from: movie.release_date)
                
                let outputDate = DateFormatter()
                outputDate.dateFormat = "dd MMM yyyy"
                
                date = outputDate.string(from: dateFormatted!)
            }
        }
    }
    
}

#Preview {
    MovieItemComponent(movie: dummyMovieInfo)
}
