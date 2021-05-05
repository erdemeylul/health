//
//  ChatRow.swift
//  Messenger
//
//  Created by Erdem Senol on 19.04.2021.
//

import SwiftUI
import URLImage

struct ChatRow: View {
    @StateObject var model = MessageViewModel()
    let type: MessageType
    
    var isSender: Bool {
        return type == .sent
    }
    
    let text: String
    
    init(text: String, type: MessageType){
        self.text = text
        self.type = type
    }
    
    var body: some View {
        HStack{
            if isSender {Spacer()}
            
            if !isSender{
                VStack{
                    Spacer()

                }
            }
            HStack{
                Text(text)
                    .foregroundColor(isSender ? Color.white : Color(.label))
                    .padding()
                    .lineLimit(nil)
            }.background(isSender ? Color.purple : Color(.systemGray4))
            //.padding(isSender ? .leading : .trailing, isSender ? UIScreen.main.bounds.width/3 : UIScreen.main.bounds.width/5)
            .cornerRadius(12)
            if !isSender {Spacer()}
        }
    }
}


