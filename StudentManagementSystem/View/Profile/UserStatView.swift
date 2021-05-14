//
//  UserStatView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI

struct UserStatView: View {
    let value: Int
    let title1: String
    let title2: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 15, weight: .semibold))
                .padding(.bottom, 5)
            
            Text(title1)
                .font(.system(size: 15))
            Text(title2)
                .font(.system(size: 15))
        }
        .frame(width: 80, alignment: .center)
    }
}


