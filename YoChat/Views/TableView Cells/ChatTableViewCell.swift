//
//  ChatTableViewCell.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
     @IBOutlet weak var profileImage:UIImageView!
     @IBOutlet weak var firstLastName:UILabel!
     @IBOutlet weak var message:UILabel!
     @IBOutlet weak var date:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
