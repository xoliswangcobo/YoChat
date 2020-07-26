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
    
    var chatsViewModel: ChatsViewModel!
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.chatsViewModel.getChats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupBinding() {
        let _ = self.chatsViewModel.chats.observeNext {  [unowned self] (chats) in
            self.tableView.reloadData()
        }.dispose(in: self.reactive.bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatsViewModel.chats.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell =  tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        let chat = self.chatsViewModel.chats.value[indexPath.row]
        
        chatCell.date.text = "\(chat.chatItems.last?.date ?? Date())"
        chatCell.firstLastName.text = chat.contact.alias
        chatCell.message.text = "\(chat.chatItems.last?.data ?? "")"
        
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toChatViewController", sender: self.chatsViewModel?.chats.value[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatViewController", let chat = sender as? Chat {
            let viewController = segue.destination as! ChatViewController
            viewController.chatItems = Observable<[ChatItem]>(chat.chatItems)
            viewController.chatContact = Observable<ChatContact>(chat.contact)
            viewController.chatItems.observeNext { items in
                chat.chatItems = items
                self.tableView.reloadData()
            }.dispose(in: viewController.reactive.bag)
        }
    }
}

