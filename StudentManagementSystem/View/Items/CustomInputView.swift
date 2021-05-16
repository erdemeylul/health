//
//  CustomInputView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/1/21.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color(.separator))
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, 8)
            
            HStack {
                TextField("Yorum...", text: $inputText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(minHeight: 30)
                    .foregroundColor(.primary)
                
                Button(action: action) {
                    Text("Gönder")
                        .bold()
                        .foregroundColor(.primary)
                }
            }
            .padding(.bottom, 8)
            .padding(.horizontal)
        }
    }
}
