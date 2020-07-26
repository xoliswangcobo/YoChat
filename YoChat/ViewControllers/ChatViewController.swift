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

class ChatViewController: KeyboardManagedViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var chatItems: Observable<[ChatItem]>!
    var chatContact: Observable<ChatContact>!
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var textMessage:UITextField!
    @IBOutlet weak var sendButton:UIButton!
    
    let imagePickerController = UIImagePickerController()
    let actionsheet = UIAlertController(title: "Send Photo", message: "Choose Photo", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePickerController.delegate = self
        
        self.actionsheet.addAction(UIAlertAction(title: "Camera", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }  else {
                print("Camera is Not Available")
            }
        })
        
        self.actionsheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                print("PhotoLibrary is Not Available")
            }
        })
            
        self.actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(selectImage))
    }
    
    @objc func selectImage() {
        self.present(self.actionsheet,animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        
        picker.dismiss(animated: true) {
            let base64Image = image.pngData()?.base64EncodedString(options: .lineLength64Characters)
            self.sendData(type: .Image, data: base64Image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true)
    }
    
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
            self.sendData(type: .Text, data: self.textMessage.text)
            self.textMessage.text = ""
            self.sendButton.isEnabled = false
        }.dispose(in: self.reactive.bag)
        
        let _ = self.textMessage.reactive.text.observeNext { [unowned self] (text) in
            self.sendButton.isEnabled = text?.count ?? 0 > 0
        }.dispose(in: self.reactive.bag)
        
        let _ = self.chatItems.observeNext { [unowned self] (items) in
            self.tableView.reloadData()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                self.tableView.scrollTableViewToBottom(animated: true)
            }
        }.dispose(in: self.reactive.bag)
    }
    
    func sendData(type:ChatItemType, data:String?) {
        do {
            let item:ChatItem? = try ChatItem.decode([ "id" : "msg_\(Date().description)", "type" : type.rawValue, "isIncoming" : false, "data" : data ?? "" ])
            if let chatItem = item {
                self.chatItems.value.append(chatItem)
            }
        } catch let e {
            print(e)
        }
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
            chatCell.setIncoming(item.isIncoming)
            
            return chatCell
        } else {
            let chatCell = tableView.dequeueReusableCell(withIdentifier: "ChatImage", for: indexPath) as! ChatItemImageTableViewCell
            let dataDecoded : Data = Data(base64Encoded: item.data, options: .ignoreUnknownCharacters)!
            chatCell.messageImage.image = UIImage(data: dataDecoded)
            item.date = Date()
            chatCell.date.text = item.date?.dateShort()
            chatCell.setIncoming(item.isIncoming)
            
            return chatCell
        }
    }
}
