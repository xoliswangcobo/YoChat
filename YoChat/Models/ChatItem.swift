//
//  ChatItem.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

enum ChatItemType: String, Codable {
    case Image
    case Text
}

class ChatItem: Codable {
    var id: String
    var type: ChatItemType
    var data: String
    var date: Date
    var isIncoming: Bool
}
