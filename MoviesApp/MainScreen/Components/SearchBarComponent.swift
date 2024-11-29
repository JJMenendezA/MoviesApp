//
//  SearchBarComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 03/11/24.
//

import SwiftUI

struct SearchBarComponent: View {
    @Binding var textSearch: String
    @FocusState private var isFocused: Bool
    @Binding var isSearchBarFocused: Bool
    var body: some View {
        HStack {
            HStack{
                Image(systemName: "magnifyingglass")
                
                TextField("",
                          text: $textSearch,
                          prompt: Text("Search Movies")
                    .foregroundStyle(.white.opacity(0.5)))
                .submitLabel(.done)
                .focused($isFocused)
                .tint(.white)
                
                if !textSearch.isEmpty {
                    Button(action: {
                        textSearch = ""
                    }){
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.white.opacity(0.5))
                    } // :Button
                }
            } // :HStack
            .padding()
            .background(.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            if isFocused {
                Button(action: {
                    textSearch = ""
                    isFocused = false
                }) {
                    Text("Cancel")
                } // :Button
            }
        } // :HStack
        .foregroundStyle(.white)
        .padding()
        .onChange(of: isFocused){
            withAnimation {
                isSearchBarFocused = isFocused
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchBarComponent(textSearch: .constant(""), isSearchBarFocused: .constant(true))
        .background(.gray900)
}
