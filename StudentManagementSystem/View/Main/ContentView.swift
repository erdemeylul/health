//
//  ContentView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var selectedIndex = 0
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                if !UserDefaults.standard.bool(forKey: "didLaunchBefore"){
                    OnboardingView()
                }else{
                    LoginView()
                }
            }else{
                if viewModel.currentUser?.role == "seller"{
                    if let user = viewModel.currentUser{
                        MainTabView(user: user, selectedIndex: $selectedIndex)
                    }
                }else if viewModel.currentUser?.role == "buyer" {
                    if let user = viewModel.currentUser{
                        MainTabView(user: user, selectedIndex: $selectedIndex)
                    }
                }else{
                    ProgressView()
                        .onAppear{
                            viewModel.fetchUser()
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
