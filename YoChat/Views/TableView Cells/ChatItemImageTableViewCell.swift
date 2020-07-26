//
//  ChatItemImageTableViewCell.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class ChatItemImageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageImage:UIImageView!
    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var date:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.message.text = "Photo"
    }
}
