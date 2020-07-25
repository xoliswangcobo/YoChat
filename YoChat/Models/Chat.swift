//
//  Chat.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

class Chat: Codable {
    var id: String
    var chatItems: [ChatItem]
    var contact: ChatContact
}
