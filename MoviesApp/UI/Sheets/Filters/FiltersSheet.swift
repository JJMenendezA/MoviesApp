//
//  FiltersSheet.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 04/11/24.
//

import SwiftUI

struct FiltersSheet: View {
    @Binding var isSheetActive: Bool
    @State var language: String = "All languages"
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @ObservedObject var mainViewModel: MainViewModel
    @EnvironmentObject var appSettings: AppSettings
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
                        SharedComponentsLeadAligned {
                            Text("Language:")
                                .fontWeight(.light)
                                .font(.callout)
                        }
                        
                        Spacer()
                        
                        Menu {
                            ForEach(mainViewModel.languagesArray, id: \.self) { optionLanguage in
                                Button(action: ({ language = optionLanguage })) {
                                    HStack {
                                      createLanguageText(code: optionLanguage)
                                        if language == optionLanguage {
                                            Image(systemName: "checkmark")
                                        }
                                    } // :HStack
                                }
                            }
                        } label: {
                            createLanguageText(code: language)
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 40)
                        }
                        .padding(.trailing)
                    } // :HStack
                    .padding(.vertical)
                    
                    if let firstElement = mainViewModel.releaseDatesArray.first,
                       let lastElement = mainViewModel.releaseDatesArray.last {
                        
                        if firstElement <= endDate {
                            HStack {
                                SharedComponentsLeadAligned {
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
                                SharedComponentsLeadAligned {
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
                    if mainViewModel.filterParameters.areFiltersApplied {
                        SharedComponentsButton(text: "Clean Filters",
                                        colorGradient: customLinearGradient(colors: [.pink700, .pink900]),
                                        shape: .capsule,
                                        fontWeight: .bold) {
                            withAnimation {
                                isSheetActive = false
                                mainViewModel.filterParameters.cleanFilters()
                            }
                        }
                        .padding(.horizontal, 5)
                        
                    }
                    
                    SharedComponentsButton(text: "Ready",
                                    colorGradient: customLinearGradient(colors: [.purple700, .purple900]),
                                    shape: .capsule,
                                    fontWeight: .bold) {
                        withAnimation {
                            mainViewModel.filterParameters.language = self.language
                            mainViewModel.filterParameters.startDate = self.startDate
                            mainViewModel.filterParameters.endDate = self.endDate
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
            language = mainViewModel.filterParameters.language
            endDate = mainViewModel.filterParameters.endDate
            startDate = mainViewModel.filterParameters.startDate
        }
    }

    private func createLanguageText(code: String) -> some View {
        if code == "All languages" || code == "Todos los idiomas" {
            return Text("All languages")
        }
        return Text((appSettings.locale.localizedString(forLanguageCode: code) ?? code).capitalized)
    }
}

#Preview {
    FiltersSheet(isSheetActive: .constant(true),
                      mainViewModel: MainViewModel(fetchMoviesUseCase: MockFetchMoviesUseCase(),
                                                   fetchMovieUseCase: MockFetchMovieDetailsUseCase(),
                                                   createLanguageArrayUseCase: CreateLanguageArrayUseCaseImpl(),
                                                   createDateArrayUseCase: CreateDateArrayUseCaseImpl(),
                                                   filterMoviesUseCase: FilterMoviesUseCaseImpl(),
                                                   searchMoviesByTitleUseCase: SearchMoviesByTitleUseCaseImpl()))
}
