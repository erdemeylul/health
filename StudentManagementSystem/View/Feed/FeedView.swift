//
//  FeedView.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @EnvironmentObject var model: AuthViewModel
    @State var show = false

    
    var body: some View {
        
        ScrollView{
           
            VStack(spacing: 32){
                if !viewModel.users.isEmpty{
                    ForEach(viewModel.posts){ post in
                        FeedCell(viewModel: FeedCellViewModel(post: post))
                    }
                }
            }.onAppear{
                viewModel.fetchFollowers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    show = true
                }
            }
            .padding(.top)
        }
    }
}

