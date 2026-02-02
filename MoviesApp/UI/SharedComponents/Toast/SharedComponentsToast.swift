//
//  SharedComponentsToast.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 24/11/25.
//  Copyright © 2025 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct SharedComponentsToast: View {
    var text: String?
    var textLocalized: LocalizedStringResource?
    @Binding var isToastActive: Bool
    init(text: String,
         isToastActive: Binding<Bool>) {
        self.text = text
        self._isToastActive = Binding(projectedValue: isToastActive)
    }
    init(textLocalized: LocalizedStringResource,
         isToastActive: Binding<Bool>) {
        self.textLocalized = textLocalized
        self._isToastActive = Binding(projectedValue: isToastActive)
    }
    @ViewBuilder
    var textComponent: some View {
        if let notLocalizedText = text {
            Text(notLocalizedText)
        } else if let localizedText = textLocalized {
            Text(localizedText)
        } else {
            EmptyView()
        }
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.black)
            .overlay {
                textComponent
            }
            .frame(height: 50)
            .padding()
            .opacity(isToastActive ? 1 : 0)
    }
}

#Preview {
    SharedComponentsToast(text: "Test", isToastActive: .constant(true))
}
