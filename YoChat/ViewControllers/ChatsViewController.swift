//
//  ChatsViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatsViewModel: ChatsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatsViewModel?.chats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell =  tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as! ChatTableViewCell
        
        let chat = self.chatsViewModel?.chats[indexPath.row]
        
        chatCell.date.text = "\(chat?.chatItems.last?.date ?? Date())"
        chatCell.firstLastName.text = chat?.contact.alias
        
        return chatCell
    }
}

