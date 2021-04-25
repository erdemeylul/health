//
//  StudentLogin.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 18.04.2021.
//

import SwiftUI

struct StudentLogin: View {
    var body: some View {
        VStack{
            Text("Student")
            Button {
                AuthViewModel.shared.signout()
            } label: {
                Text("Logout").foregroundColor(.black)
            }
        }
    }
}

struct StudentLogin_Previews: PreviewProvider {
    static var previews: some View {
        StudentLogin()
    }
}
