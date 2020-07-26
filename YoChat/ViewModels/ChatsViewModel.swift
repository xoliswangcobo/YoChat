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
    
    var chats = Observable<[Chat]>([])
 
    func getChats() {
        var someChats:[Chat] = []
        
        do {
            if let chat:Chat = try Chat.decode(["id" : "101_\(1)", "chatItems" : [], "contact" : [ "firstname" : "Xoliswa", "lastname" : "Ngcobo", "email" : "xoliswa@ngcobo.com", "alias" : "eXo"]]) {
                someChats.append(chat)
            }
        } catch (let e) {
            print(e)
        }
        
        self.chats.send(someChats)
    }
}
