//
//  AddButtonStyle.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 1/3/24.
//

import SwiftUI


struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0) // Shrink slightly when pressed
            .foregroundStyle(configuration.isPressed ? Color.gray : Color.accent)
    }
}
