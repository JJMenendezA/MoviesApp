//
//  FiltersScreenView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/11/24.
//

import SwiftUI

struct FiltersScreenView: View {
    @Binding var isSheetActive: Bool
    @State var filterLanguage: String = NSLocalizedString("All languages", comment: "")
    @State var filterStartReleaseDate: Date = Date()
    @State var filterEndReleaseDate: Date = Date()
    @ObservedObject var mainScreenViewModel: MainScreenViewModel
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: ({ isSheetActive = false })) {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    } // :Button
                    Spacer()
                    Text("Select the desired parameters")
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(.horizontal, 5)
                        .padding(10)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Spacer()
                } // :HStack
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    HStack {
                        LeadAlignedView {
                            Text("Language:")
                                .fontWeight(.light)
                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Menu(filterLanguage) {
                            ForEach(mainScreenViewModel.languagesArray, id: \.self) { language in
                                Button(action: ({ filterLanguage = language })) {
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
                    
                    if let firstElement = mainScreenViewModel.releaseDatesArray.first,
                       let lastElement = mainScreenViewModel.releaseDatesArray.last {
                        
                        if firstElement <= filterEndReleaseDate {
                            HStack {
                                LeadAlignedView {
                                    Text("Starting release date:")
                                        .fontWeight(.light)
                                        .font(.callout)
                                }
                                
                                DatePicker("Starting release date:",
                                           selection: $filterStartReleaseDate,
                                           in: firstElement...filterEndReleaseDate,
                                           displayedComponents: .date)
                                .labelsHidden()
                                .tint(.purple700)
                                .padding(.trailing)
                                .colorScheme(.dark)
                            } // :HStack
                            .padding(.vertical)
                        }
                        
                        if filterStartReleaseDate <= lastElement {
                            HStack {
                                LeadAlignedView {
                                    Text("End release date:")
                                        .fontWeight(.light)
                                        .font(.callout)
                                }
                                DatePicker("End release date:",
                                           selection: $filterEndReleaseDate,
                                           in: filterStartReleaseDate...lastElement,
                                           displayedComponents: .date)
                                    .labelsHidden()
                                    .tint(.purple700)
                                    .padding(.trailing)
                                    .colorScheme(.dark)
                            } // :HStack
                            .padding(.vertical)
                        }
                    }
                    
                } // :ScrollView
                
                HStack {
                    if mainScreenViewModel.filterParameters.areFiltersApplied {
                        ButtonComponent(text: NSLocalizedString("Clean Filters", comment: ""),
                                        colorGradient: customLinearGradient(colors: [.pink700, .pink900]),
                                        shape: .capsule,
                                        fontWeight: .bold) {
                            withAnimation {
                                isSheetActive = false
                                mainScreenViewModel.filterParameters.cleanFilters()
                            }
                        }
                        .padding(.horizontal, 5)
                        
                    }
                    
                    ButtonComponent(text: NSLocalizedString("Ready", comment: ""),
                                    colorGradient: customLinearGradient(colors: [.purple700, .purple900]),
                                    shape: .capsule,
                                    fontWeight: .bold) {
                        withAnimation {
                            mainScreenViewModel.filterParameters.language = self.filterLanguage
                            mainScreenViewModel.filterParameters.startDate = self.filterStartReleaseDate
                            mainScreenViewModel.filterParameters.endDate = self.filterEndReleaseDate
                            isSheetActive = false
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
        .onAppear {
            filterLanguage = mainScreenViewModel.filterParameters.language
            filterEndReleaseDate = mainScreenViewModel.filterParameters.endDate
            filterStartReleaseDate = mainScreenViewModel.filterParameters.startDate
        }
    }
}

#Preview {
    FiltersScreenView(isSheetActive: .constant(true),
                      mainScreenViewModel: MainScreenViewModel(fetchMoviesUseCase: MockFetchMoviesUseCase()))
}
