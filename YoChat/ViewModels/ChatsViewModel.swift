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
        
        for index in 0..<10 {
            do {
                if let chat:Chat = try Chat.decode(["id" : "101_\(index)", "chatItems" : [], "contact" : [ "firstname" : "Xoliswa", "lastname" : "Ngcobo", "email" : "xoliswa@ngcobo.com", "alias" : "eXo"]]) {
                    someChats.append(chat)
                }
            } catch (let e) {
                print(e)
            }
        }
        
        self.chats.send(someChats)
    }
}
