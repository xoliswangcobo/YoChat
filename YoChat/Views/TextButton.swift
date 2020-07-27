//
//  TextButton.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/27.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class TextButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(named: "blue_light")
        self.layer.cornerRadius = 5
    }
    
    override open var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled == true ? UIColor.init(named: "blue_light") : .lightGray
        }
    }
}
