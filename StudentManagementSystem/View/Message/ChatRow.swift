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
            }.background(isSender ? Color("kucukmor") : Color("krem"))
            .cornerRadius(12)
            .shadow(color: .gray, radius: 2, x: -5, y: 5)
            if !isSender {Spacer()}
        }
    }
}


