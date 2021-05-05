//
//  SearchView.swift
//  Messenger
//
//  Created by Erdem Senol on 19.04.2021.
//

import SwiftUI

struct SearchView2: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var model = MessageViewModel()
    
    @State var text = ""
    @State var usernames: [String] = []
    
    let completion: ((String)-> Void)
    
    init(completion: @escaping((String) -> Void)){
        self.completion = completion
    }
    
    var body: some View {
        VStack{
            TextField("Username...", text: $text)
                .modifier(CustomField())
            Button(action: {
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                    return
                }
                model.searchUsers(queryText: text){usernames in
                    self.usernames = usernames
                }
            }, label: {
                Text("Search")
            })
            
            List{
                ForEach(usernames, id:\.self){name in
                    HStack {
                        Circle()
                            .frame(width: 55, height: 55)
                            .foregroundColor(Color.green)
                        Text(name)
                            .font(.system(size: 24))
                    }.onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                        completion(name)
                    }
                }
            }
            Spacer()
            
        }.navigationTitle("Search")
    }
}

struct SearchView2_Previews: PreviewProvider {
    static var previews: some View {
        SearchView2(){_ in}
            .preferredColorScheme(.dark)
    }
}
