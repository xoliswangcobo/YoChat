//
//  ChatViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var chatItems: Observable<[ChatItem]>!
    var chatContact: Observable<ChatContact>!
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textMessage:UITextField!
    @IBOutlet weak var sendButton:UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.setupBinding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reactive.bag.dispose()
    }
    
    func setupBinding() {
        let _ = self.chatContact.observeNext { [unowned self] (contact) in
            self.navigationItem.title = contact.alias
        }.dispose(in: self.reactive.bag)
        
        let _ = self.sendButton.reactive.tap.observeNext {
            do {
                let item:ChatItem? = try ChatItem.decode([ "id" : "msg_\(Date().description)", "type" : "Text", "isIncoming" : false, "data" : self.textMessage.text ?? "" ])
                if let chatItem = item {
                    self.chatItems.value.append(chatItem)
                }
            } catch let e {
                print(e)
            }
        }.dispose(in: self.reactive.bag)
        
        let _ = self.textMessage.reactive.text.observeNext { [unowned self] (text) in
            self.sendButton.isEnabled = text?.count ?? 0 > 0
        }.dispose(in: self.reactive.bag)
        
        let _ = self.chatItems.observeNext { [unowned self] (items) in
            self.tableView.reloadData()
        }.dispose(in: self.reactive.bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.chatItems.value[indexPath.row]
        
        if item.type == .Text {
            let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatMessage", for: indexPath) as! ChatItemTableViewCell
            chatCell.message.text = item.data
            item.date = Date()
            chatCell.date.text = item.date?.dateShort()
            
            return chatCell
        } else {
            let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatImage", for: indexPath) as! ChatItemImageTableViewCell
            chatCell.message.text = item.data
            chatCell.messageImage.image = UIImage(systemName: "pencil.slash")
            chatCell.date.text = item.date?.dateShort()
            
            return chatCell
        }
    }
}
