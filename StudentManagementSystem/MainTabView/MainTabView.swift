

import SwiftUI

struct MainTabView: View {
    
    let user: User
    @Binding var selectedIndex: Int
    @StateObject var viewModel = GetUnreadMessages()
    
    
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                FeedView()
                    .onTapGesture {
                        selectedIndex = 0
                    }
                    .tabItem {
                        Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                    }.tag(0)
                
                SearchView()
                    .onTapGesture {
                        selectedIndex = 1
                    }
                    .tabItem {
                        Image(systemName: selectedIndex == 1 ? "ladybug.fill" : "ladybug")
                    }.tag(1)
                
                PhotoUploadView(tabIndex: $selectedIndex)
                    .onTapGesture {
                        selectedIndex = 2
                    }
                    .tabItem {
                        Image(systemName: selectedIndex == 2 ? "leaf.fill" : "leaf")
                    }.tag(2)
                
                NotificationsView()
                    .onTapGesture {
                        selectedIndex = 3
                    }
                    .tabItem {
                        Image(systemName: selectedIndex == 3 ? "newspaper.fill" : "newspaper")
                    }.tag(3)
                
                ProfileView(user: user)
                    .onTapGesture {
                        selectedIndex = 4
                    }
                    .tabItem {
                        Image(systemName: selectedIndex == 4 ? "person.fill" : "person")
                    }.tag(4)
            }
            .navigationTitle(tabTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: logoutButton, trailing: NavigationLink(
                destination: ConversationListView(),
                label: {
                    ZStack{
                        Image(systemName: "envelope.circle")
                            .font(.system(size:33))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color("koyuyesil"))
                            .frame(width: 60, height:60)
                        Circle()
                            .foregroundColor(Color.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 10, y: -10)
                            .opacity(viewModel.unreadMessage.count > 0 ? 1 : 0)
                    }.onAppear{
                        viewModel.getUnreadMessages()
                    }
                }))

            .accentColor(Color("koyuyesil"))
        }.accentColor(Color("koyuyesil"))
    }
    
    var logoutButton: some View {
        Button {
            AuthViewModel.shared.signout()
        } label: {
            Text("Çıkış").foregroundColor(Color("kucukmor"))
        }
    }
    

    
    var tabTitle: String {
        switch selectedIndex {
        case 0: return "Ana Sayfa"
        case 1: return "Keşfet"
        case 2: return "Paylaş"
        case 3: return "Bildirimler"
        case 4: return "Profil"

        default: return ""
        }
    }
}

