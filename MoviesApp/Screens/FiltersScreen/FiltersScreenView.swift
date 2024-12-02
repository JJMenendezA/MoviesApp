//
//  FiltersScreenView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/11/24.
//

import SwiftUI

struct FiltersScreenView: View {
    @Binding var isSheetActive: Bool
    @ObservedObject var mainScreenViewModel: MainScreenViewModel
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        if mainScreenViewModel.filterLanguage.isEmpty {
                            mainScreenViewModel.areFiltersApplied = false
                        }
                        isSheetActive = false
                    }) {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    } // :Button
                    Spacer()
                    Text("Select the desired parameters")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(.horizontal, 5)
                        .padding(10)
                    Spacer()
                } // :HStack
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    HStack {
                        TextAlignedLeadingComponent(text: "Original language:")
                            .fontWeight(.light)
                            .font(.callout)
                        
                        Spacer()
                        
                        Menu(mainScreenViewModel.filterLanguage) {
                            ForEach (mainScreenViewModel.originalLanguagesList, id: \.self) { language in
                                Button(action: {
                                    mainScreenViewModel.filterLanguage = language
                                }){
                                    Text(language)
                                }
                            }
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 40)
                        }
                        .padding(.trailing)
                        .foregroundStyle(.white)
                    } // :HStack
                    .padding(.vertical)
                    
                    if let firstElement = mainScreenViewModel.releaseDatesList.first,
                       let lastElement = mainScreenViewModel.releaseDatesList.last {
                        HStack {
                            TextAlignedLeadingComponent(text: "Starting release date:")
                                .fontWeight(.light)
                                .font(.callout)
                            
                            DatePicker("", selection: $mainScreenViewModel.filterStartReleaseDate, in: firstElement...mainScreenViewModel.filterEndReleaseDate, displayedComponents: .date)
                                .labelsHidden()
                                .tint(.pink700)
                                .padding(.trailing)
                                .colorScheme(.dark)
                        } // :HStack
                        .padding(.vertical)
                        
                        HStack {
                            TextAlignedLeadingComponent(text: "End release date:")
                                .fontWeight(.light)
                                .font(.callout)
                            
                            DatePicker("", selection: $mainScreenViewModel.filterEndReleaseDate, in: mainScreenViewModel.filterStartReleaseDate...lastElement, displayedComponents: .date)
                                .labelsHidden()
                                .tint(.pink700)
                                .padding(.trailing)
                                .colorScheme(.dark)
                        } // :HStack
                        .padding(.vertical)
                    }
                    
                } // :ScrollView
                
                HStack {
                    if mainScreenViewModel.areFiltersApplied {
                        ButtonComponent(text: "Clean Filters", colorGradient: customLinearGradient(colors: [.pink700, .pink900] ), shape: .capsule, fontWeight: .bold) {
                            withAnimation {
                                isSheetActive = false
                                mainScreenViewModel.cleanFilters()
                            }
                        }
                        .padding(.horizontal, 5)
                        
                    }
                    
                    ButtonComponent(text: "Ready", colorGradient: customLinearGradient(colors: [.purple700, .purple900] ), shape: .capsule, fontWeight: .bold) {
                        withAnimation {
                            isSheetActive = false
                            mainScreenViewModel.areFiltersApplied = true
                        }
                    }
                    .padding(.horizontal, 5)
                    
                } // :HStack
                .padding(.horizontal)
            } // :VStack
            .ignoresSafeArea(.keyboard)
            .font(.callout)
            .foregroundStyle(.white.opacity(0.8))
            .background(.gray900)
        } // :ZStack
    }
}

#Preview {
    FiltersScreenView(isSheetActive: .constant(true), mainScreenViewModel: MainScreenViewModel())
}
