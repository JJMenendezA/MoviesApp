//
//  AnnouncementItemComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI
import Kingfisher

struct AnnouncementItemComponent: View {
    var image: String
    var body: some View {
        KFImage(URL(string: image))
            .resizable()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(height: 175)
            .padding(.horizontal)
    }
}

#Preview {
    AnnouncementItemComponent(image: "")
}
