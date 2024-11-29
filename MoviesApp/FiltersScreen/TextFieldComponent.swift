//
//  TextFieldComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 08/11/24.
//

import SwiftUI

struct TextFieldComponent: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    var listItems: [String] = []
    @State var listItemsFiltered: [String] = []
    var prompt: String
    @State private var keyboardHeight: CGFloat = 0
    var yOffset: CGFloat
    private var menuHeight: CGFloat {
        UIScreen.main.bounds.height - keyboardHeight - yOffset - 50
    }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    TextField("", text: $text, prompt: Text(prompt)
                        .foregroundStyle(.white.opacity(0.8))
                        .fontWeight(.light)
                        .font(.callout))
                    .submitLabel(.done)
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                    .foregroundStyle(.pink700)
                    .fontWeight(.light)
                    .font(.callout)
                    .focused($isFocused)
                    .onSubmit {
                        text = listItemsFiltered.first ?? text
                    }
                    
                    if !text.isEmpty && isFocused {
                        Button(action: {
                            text = ""
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                } // :HStack
                .padding(.vertical, 2)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.white.opacity(0.8))
            } // :VStack
        } // :ZStack
        .keyboardHeight($keyboardHeight)
        .overlay(alignment: .bottom) {
                if isFocused {
                    List {
                        ForEach(listItemsFiltered, id: \.self ){ item in
                            Button(action: {
                                text = item
                                isFocused = false
                            }){
                                Text(item)
                            }
                        }
                    }
                    .foregroundStyle(.gray)
                    .scrollContentBackground(.hidden)
                    .offset(y: menuHeight)
                    .listStyle(InsetListStyle())
                    .frame(height: menuHeight)
                }
        } // :Overlay
        .padding(.horizontal)
        .onAppear {
            listItemsFiltered = listItems
        }
        .onChange(of: text) {
            listItemsFiltered = listItems.filter({ $0.contains(text) })
        }
        .onChange(of: isFocused){
            if !isFocused && !listItems.contains(where: { $0 == text }) {
                text = ""
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TextFieldComponent(text: .constant("Hello World!"), prompt: "Selecciona tu estado", yOffset: 346.65543619791663)
}
