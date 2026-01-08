//
//  MainComponentsHeader.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 31/10/24.
//

import SwiftUI

struct MainComponentsHeader: View {
    @EnvironmentObject var appSettings: AppSettings
    var color: Color = .clear
    var filterAction: () -> Void
    var showRatingAction: () -> Void
    var areFiltersApplied: Bool
    var isShowingRating: Bool
    // Computed Properties
    var titleFilter: String {
        areFiltersApplied ? NSLocalizedString("Filters Applied", comment: "") : NSLocalizedString("Filters", comment: "")
    }
    var filterTitleWeight: Font.Weight {
        areFiltersApplied ? .bold : .regular
    }
    var filterIcon: String {
        areFiltersApplied ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
    }
    var ratingIcon: String {
        isShowingRating ? "star.fill" : "star.slash.fill"
    }
    var body: some View {
        HStack {
            Button(action: ({ filterAction() })) {
                Text(titleFilter)
                    .fontWeight(filterTitleWeight)
                Image(systemName: filterIcon)
            } // :Button
            
            Spacer()
            Button(action: ({ showRatingAction() })) {
                Image(systemName: ratingIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
            } // :Button
            .padding(.horizontal)
            
            Menu {
                Button(action: { appSettings.selectedLanguage = "en" },
                       label: {
                    HStack {
                       Text("English")
                        if appSettings.selectedLanguage == "en" {
                            Image(systemName: "checkmark")
                        }
                    } // :HStack
                })
                Button(action: { appSettings.selectedLanguage = "es" },
                       label: {
                    HStack {
                       Text("Spanish")
                        if appSettings.selectedLanguage == "es" {
                            Image(systemName: "checkmark")
                        }
                    } // :HStack
                })
            } label: {
                Label(title: { EmptyView() }, icon: {
                    Image(systemName: "globe")
                        .resizable()
                        .frame(width: 20, height: 20)
                })
            }
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
    MainComponentsHeader(filterAction: {}, showRatingAction: {}, areFiltersApplied: false, isShowingRating: false)
        .background(.black)
}
