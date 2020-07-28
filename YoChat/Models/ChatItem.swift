//
//  ChatItem.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import SocketIO

enum ChatItemType: String, Codable {
    case Image
    case Text
}

class ChatItem: Codable {
    var id: String
    var type: ChatItemType!
    var data: String
    var date: Date?
    var isIncoming: Bool
    var from: String?
    var to: String?
    
    private enum CodingKeys : String, CodingKey {
        case id, type, date, data, isIncoming, from, to
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.type = try container.decodeIfPresent(ChatItemType.self, forKey: .type)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)!
        self.isIncoming = try container.decodeIfPresent(Bool.self, forKey: .isIncoming)!
        self.from = try container.decodeIfPresent(String.self, forKey: .from) ?? nil
        self.to = try container.decodeIfPresent(String.self, forKey: .to) ?? nil
        
        let aDate = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
        self.date = Date.dateFrom(date: aDate)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.data, forKey: .data)
        try container.encode(self.date?.dateString(), forKey: .date)
        try container.encode(self.isIncoming, forKey: .isIncoming)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.to, forKey: .to)
    }

}

extension ChatItem: SocketData {
    
    func socketRepresentation() -> SocketData {
        do {
            if let data = try ChatItem.encode(decoded: self) as? SocketData {
                return data
            } else {
                return [:]
            }
            
        } catch {
            return [:]
        }
    }
}
