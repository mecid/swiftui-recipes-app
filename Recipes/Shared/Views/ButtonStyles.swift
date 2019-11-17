//
//  ButtonStyles.swift
//  Recipes
//
//  Created by Majid Jabrayilov on 11/17/19.
//  Copyright © 2019 Majid Jabrayilov. All rights reserved.
//
import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .multilineTextAlignment(.center)
            .fixedSize()
            .padding()
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .background(Color.accentColor)
            .cornerRadius(8)
    }
}
