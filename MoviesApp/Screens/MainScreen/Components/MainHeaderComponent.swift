//
//  MainHeader.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI

struct MainHeaderComponent: View {
    var color: Color = .clear
    var filterAction: () -> ()
    var switchAction: () -> ()
    var submenuAction: () -> ()
    @Binding var areFiltersApplied: Bool
    // Computed Properties
    var titleFilter: String {
        areFiltersApplied ? "Filters Applied" : "Filters"
    }
    var filterTitleWeight: Font.Weight {
        areFiltersApplied ? .bold : .regular
    }
    var filterIcon: String {
        areFiltersApplied ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
    }
    var body: some View {
        HStack {
            Button(action: {
                filterAction()
            }){
                Text(titleFilter)
                    .fontWeight(filterTitleWeight)
                Image(systemName: filterIcon)
            } // :Button
            
            Spacer()
            Button(action: {
                switchAction()
            }){
                Image(systemName: "tv")
                    .resizable()
                    .frame(width: 20, height: 20)
            } // :Button
            .padding(.horizontal)
            .hidden()
            
            Button(action: {
                submenuAction()
            }){
                Image(systemName: "info.bubble")
                    .resizable()
                    .frame(width: 20, height: 20)
            } // :Button
            .hidden()
           
        } // :HStack
        .padding(.horizontal)
        .foregroundStyle(.white)
        .zIndex(1)
        .padding(.top, 50)
        .padding(.bottom)
        .background(color)
    }
}

#Preview {
    MainHeaderComponent(filterAction: {}, switchAction: {}, submenuAction: {}, areFiltersApplied: .constant(false))
        .background(.black)
}
