//
//  ChatsViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatsViewModel: ChatsViewModel?
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.chatsViewModel?.getChats()
    }

    func setupBinding() {
        let _ = self.chatsViewModel?.chats.observeNext {  [unowned self] (chats) in
            self.tableView.reloadData()
        }.dispose(in: self.reactive.bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatsViewModel?.chats.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell =  tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        let chat = self.chatsViewModel?.chats.value[indexPath.row]
        
        chatCell.date.text = "\(chat?.chatItems.last?.date ?? Date())"
        chatCell.firstLastName.text = chat?.contact.alias
        
        return chatCell
    }
}

