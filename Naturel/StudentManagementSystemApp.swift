//
//  StudentManagementSystemApp.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 17.04.2021.
//

import SwiftUI
import Firebase


@main
struct StudentManagementSystemApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        }
    }
}
