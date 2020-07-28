//
//  CoreChatMessaging.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/28.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import SocketIO

class CoreChatMessaging {
    
    enum Operation: String, Codable {
        case SendChat
        case RecieveChat
        case Connect
        case Disconnect
    }
    
    var socketHandler:((Operation, Any) -> Void)?
    private var socket:SocketIO.SocketIOClient!
    private var manager:SocketManager!
    
    class func start(url: String) -> CoreChatMessaging {
        let coreMessaging = CoreChatMessaging()
        coreMessaging.manager = SocketManager(socketURL: URL(string: url)!, config: [.log(true), .compress])
        coreMessaging.socket = coreMessaging.manager.defaultSocket

        coreMessaging.socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            coreMessaging.socketHandler?(Operation.Connect, data)
        }
        
        coreMessaging.socket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected")
            coreMessaging.socketHandler?(Operation.Disconnect, data)
        }

        coreMessaging.socket.on(Operation.RecieveChat.rawValue) { data, ack in
            print("socket message recieve...")
            coreMessaging.socketHandler?(Operation.RecieveChat, (data.first as? [String:Any])?["message"] ?? [:])
        }
        
        coreMessaging.socket.on(Operation.SendChat.rawValue) { data, ack in
            print("socket message send...")
            coreMessaging.socketHandler?(Operation.SendChat, data)
        }
        
        coreMessaging.socket.onAny {print("Got event: \($0.event), with items: \($0.items!)")}

        coreMessaging.socket.connect(timeoutAfter: 5) {
            print("Connection: \(coreMessaging.socket.status.rawValue)")
        }
        
        return coreMessaging
    }
    
    func send(message:SocketData) {
        self.socket.emit(Operation.SendChat.rawValue, message)
    }
}
