//
//  KeyboardUtils.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 14/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import SwiftUI

struct KeyboardProvider: ViewModifier {
    
    var keyboardHeight: Binding<CGFloat>
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification),
                       perform: { notification in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                                                            
                self.keyboardHeight.wrappedValue = keyboardRect.height
                
            }).onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification),
                         perform: { _ in
                self.keyboardHeight.wrappedValue = 0
            })
    }
}


public extension View {
    func keyboardHeight(_ state: Binding<CGFloat>) -> some View {
        self.modifier(KeyboardProvider(keyboardHeight: state))
    }
}

struct MeasureYOffsetModifier: ViewModifier {
    @Binding var yOffset: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            yOffset = geometry.frame(in: .global).minY
                        }
                        .onChange(of: geometry.frame(in: .global)) {
                            yOffset = geometry.frame(in: .global).minY
                        }
                }
            )
    }
}

extension View {
    func measureYOffset(_ yOffset: Binding<CGFloat>) -> some View {
        self.modifier(MeasureYOffsetModifier(yOffset: yOffset))
    }
}
