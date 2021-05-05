

import SwiftUI
import Kingfisher
import URLImage

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack {
//            KFImage(URL(string: user.profileImageUrl))
//                .resizable()
//                .scaledToFill()
//                .frame(width: 48, height: 48)
//                .clipShape(Circle())
            URLImage(url: URL(string: user.profileImageUrl)!) {image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }
            
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
