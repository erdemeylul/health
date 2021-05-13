//
//  FeedView.swift
//  StudentManagementSystem
//
//  Created by Erdem Senol on 23.04.2021.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State var scrollViewOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { proxyReader in
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
                .id("SCROLL_TO_TOP")
                .overlay(
                    GeometryReader{ proxy -> Color in
                        DispatchQueue.main.async {
                            if startOffset == 0{
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                            
                            let offset = proxy.frame(in: .global).minY
                            self.scrollViewOffset = offset - startOffset
                        }
                        
                        return Color.clear
                    }.frame(width: 0, height: 0), alignment: .top
                )
            }
            .overlay(
                Button(action: {
                    withAnimation(.spring()){
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                }, label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                }).padding(.trailing)
                .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0)
                .opacity(-scrollViewOffset > 450 ? 1 : 0)
                .animation(.easeInOut)
                , alignment: .bottomTrailing
        )
        }
    }
    
}

extension View{
    func getSafeArea()->UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

