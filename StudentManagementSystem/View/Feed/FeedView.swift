//
//  FeedView.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        ScrollView{
            VStack(spacing: 32){
                if !viewModel.users.isEmpty{
                    ForEach(viewModel.posts){ post in
                        FeedCell(viewModel: FeedCellViewModel(post: post))
                    }
                }
            }.onAppear{
                //viewModel.fetchPosts()
                viewModel.fetchFollowers()
            }
            .padding(.top)
        }
    }
    
}

