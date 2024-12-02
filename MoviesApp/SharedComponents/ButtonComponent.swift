//
//  ButtonComponent.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 06/11/24.
//

import SwiftUI

struct ButtonComponent<ShapeType: Shape>: View {
    var text: String
    var colorGradient: LinearGradient
    var shape: ShapeType
    var fontWeight: Font.Weight = .regular
    var font: Font = .body
    var action: () -> ()
    // Computed property
    var body: some View {
        Button(action:{
            action()
        }){
            HStack {
                Spacer()
                Text(text)
                    .foregroundStyle(.white)
                    .fontWeight(fontWeight)
                    .font(font)
                Spacer()
            } // :HStack
            .padding(.vertical)
            .background(colorGradient)
            .clipShape(shape)
        } // :Button
    }
}

#Preview {
    ButtonComponent(text: "Listo", colorGradient: LinearGradient(colors: [.pink700, .pink900], startPoint: .bottomLeading, endPoint: .topTrailing), shape: .capsule){
        
    }
}
