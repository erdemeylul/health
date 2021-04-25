//
//  UserCell.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI
import Kingfisher

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(user.role)
                    .font(.system(size: 14))
            }
            
            Spacer()
        }
    }
}
