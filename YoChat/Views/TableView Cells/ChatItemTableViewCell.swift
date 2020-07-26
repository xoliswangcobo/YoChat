//
//  ChatItemTableViewCell.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class ChatItemTableViewCell: UITableViewCell {

    @IBOutlet weak var message:UILabel!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var leading:NSLayoutConstraint!
    @IBOutlet weak var trailing:NSLayoutConstraint!

    func setIncoming(_ isIncoming:Bool) {
        if isIncoming == false {
            self.leading.constant = 32
            self.trailing.constant = 16
            self.date.textAlignment = .right
        } else {
            self.trailing.constant = 32
            self.leading.constant = 16
            self.date.textAlignment = .left
        }
    }

}
