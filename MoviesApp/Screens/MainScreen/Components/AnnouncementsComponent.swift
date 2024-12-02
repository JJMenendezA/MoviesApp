//
//  AnnouncementsComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//


import SwiftUI

struct AnnouncementsComponent: View {
    @State var selectedIndex: Int = 0
    // Timer to set up the autoscroll
    let timer = Timer.publish(every: 10.0, on: .main, in: .common).autoconnect()
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<announcementsList.count, id: \.self){ index in
                AnnouncementItemComponent(image: announcementsList[index])
                    .padding(.bottom, 40)
            }
        } // :TabView
        .tabViewStyle(.page)
        .foregroundStyle(.pink700)
        .frame(height: 220)
        .onAppear{
            // Change the color of the dots
            UIPageControl.appearance().currentPageIndicatorTintColor = .pink700
            UIPageControl.appearance().pageIndicatorTintColor = .gray
        }
        // Autoscrolling logic
        .onReceive(timer){ _ in
            withAnimation(.default) {
                selectedIndex = (selectedIndex + 1) % announcementsList.count
            }
        }
    }
}

#Preview {
    AnnouncementsComponent()
        .background(.black)
}
