//
//  AfterLogin.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 18.04.2021.
//

import SwiftUI

struct AfterLogin: View {
    @State var selectedIndex = 0
    
    var body: some View {
        NavigationView {
            VStack{
                Button {
                    AuthViewModel.shared.signout()
                } label: {
                    Text("Logout").foregroundColor(.black)
                }
            }
        }
    }
}

struct AfterLogin_Previews: PreviewProvider {
    static var previews: some View {
        AfterLogin()
    }
}
