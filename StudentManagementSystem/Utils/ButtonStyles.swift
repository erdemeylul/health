//
//  ButtonStyles.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 10.05.2021.
//

import Foundation
import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("arkaplan"), Color("kahve")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}
