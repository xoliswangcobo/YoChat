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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addChat(sender:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func addChat(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "toAddChat", sender: sender)
    }
    
    func setupBinding() {
        let _ = self.chatsViewModel.chats.observeNext {  [unowned self] (chats) in
            self.tableView.reloadData()
        }.dispose(in: self.reactive.bag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatsViewModel.chats.collection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell =  tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatTableViewCell
        
        let chat = self.chatsViewModel.chats.collection[indexPath.row]
        let item = chat.chatItems.sorted { Int($0.date?.timeIntervalSince1970 ?? 0) > Int($1.date?.timeIntervalSince1970 ?? 0) }.last
        chatCell.date.text = item?.date?.dateShort() ?? ""
        chatCell.firstLastName.text = chat.contact.alias
        chatCell.message.text = item != nil ? (item?.type == ChatItemType.Text ? item?.data : "Photo") : "No messages"
        
        return chatCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "toChatViewController", sender: self.chatsViewModel?.chats.collection[indexPath.row])
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
            
            Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer) in
                do {
                    let item:ChatItem? = try ChatItem.decode([ "id" : "msg_\(Date().description)", "type" : "Text", "isIncoming" : true, "data" : "Helloo" ])
                if let chatItem = item {
                    viewController.chatItems.value.append(chatItem)
                }
                } catch {
                    
                }
            }
        } else if segue.identifier == "toAddChat" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! AddChatViewController
            viewController.completionHandler = { contact in
                if let contact = contact {
                    let _ = self.chatsViewModel.chats.observeNext { chats in
                        if (chats.collection.first(where: { $0.contact.email == contact.email }) != nil) {
                            viewController.dismiss(animated: true)
                        } else {
                            MessageView.showMessage(title: "Add Chat", message: "Can not add the contact.", viewController: viewController, actions: [("Okay", {
                                
                            })])
                        }
                    }.dispose(in: viewController.reactive.bag)
                    self.chatsViewModel.addChat(contact: contact)
                } else {
                    
                }
            }
        }
    }
}

