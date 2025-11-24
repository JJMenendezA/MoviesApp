//
//  FiltersSheetView.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/11/24.
//

import SwiftUI

struct FiltersSheetView: View {
    @Binding var isSheetActive: Bool
    @State var language: String = NSLocalizedString("All languages", comment: "")
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
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
                        
                        Menu(language) {
                            ForEach(mainScreenViewModel.languagesArray, id: \.self) { optionLanguage in
                                Button(action: ({ language = optionLanguage })) {
                                    Text(optionLanguage)
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
                        
                        if firstElement <= endDate {
                            HStack {
                                LeadAlignedView {
                                    Text("Starting release date:")
                                        .fontWeight(.light)
                                        .font(.callout)
                                }
                                
                                DatePicker("Starting release date:",
                                           selection: $startDate,
                                           in: firstElement...endDate,
                                           displayedComponents: .date)
                                .labelsHidden()
                                .tint(.purple700)
                                .padding(.trailing)
                                .colorScheme(.dark)
                            } // :HStack
                            .padding(.vertical)
                        }
                        
                        if startDate <= lastElement {
                            HStack {
                                LeadAlignedView {
                                    Text("End release date:")
                                        .fontWeight(.light)
                                        .font(.callout)
                                }
                                DatePicker("End release date:",
                                           selection: $endDate,
                                           in: startDate...lastElement,
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
                            mainScreenViewModel.filterParameters.language = self.language
                            mainScreenViewModel.filterParameters.startDate = self.startDate
                            mainScreenViewModel.filterParameters.endDate = self.endDate
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
            language = mainScreenViewModel.filterParameters.language
            endDate = mainScreenViewModel.filterParameters.endDate
            startDate = mainScreenViewModel.filterParameters.startDate
        }
    }
}

#Preview {
    FiltersSheetView(isSheetActive: .constant(true),
                      mainScreenViewModel: MainScreenViewModel(fetchMoviesUseCase: MockFetchMoviesUseCase()))
}
