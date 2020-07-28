//
//  ChatsViewModel.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/26.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Bond

class ChatsViewModel {
    
    var chats = MutableObservableArray<Chat>([])
    private let coreChat:CoreChatMessaging!
    private let user: User!
    
    init(coreChatMessaging:CoreChatMessaging, user:User) {
        self.user = user
        self.coreChat = coreChatMessaging
        self.coreChat.socketHandler = { op, data in
            print("CCM: \(op.rawValue)")
            print("CCM: \(data)")
            
            do {
                if let item:ChatItem = try ChatItem.decode(data) {
                    if let chat = self.chats.collection.first(where: { $0.contact.email.lowercased() == item.from?.lowercased() }) {
                        item.isIncoming = true
                        chat.chatItems.append(item)
                        self.chats.send(self.chats.value)
                    } else if item.to == self.user.email, item.from != self.user.email {
                         item.isIncoming = true
                        let chat:Chat? = try Chat.decode([ "chatItems" : [], "contact" : [ "firstname" : "New Contact", "lastname" : "New Contact", "email" : item.from?.lowercased(), "alias" : "New Contact"]])
                        chat?.chatItems.append(item)
                        
                        if let chat = chat {
                            self.chats.append(chat)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
 
    func getChats() {
        
    }
    
    func addChat(contact:ChatContact) {
        do {
            if let chat:Chat = try Chat.decode([ "chatItems" : [], "contact" : ChatContact.encode(decoded: contact)]) {
                self.chats.append(chat)
            }
        } catch (let e) {
            print(e)
        }
    }
    
    func sendChat(item:ChatItem) {
        item.from = self.user.email
        self.coreChat.send(message: item)
    }
}
