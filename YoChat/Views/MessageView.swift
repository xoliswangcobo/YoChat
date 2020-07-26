//
//  MessageView.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class MessageView {
    
    class func showMessage(title:String, message:String, viewController:UIViewController, style:UIAlertController.Style = .alert , actions:Array<(String, (() -> Void))>? = nil) {
        
        let alertViewController = UIAlertController.init(title: "", message: "", preferredStyle: style)
        
        let attributedTitle = NSAttributedString(string: title, attributes: [ .foregroundColor : UIColor.darkText ])
        let attributedMessage = NSAttributedString(string: "\n" + message, attributes: [ .foregroundColor : UIColor.darkText ])
        
        alertViewController.setValuesForKeys(["attributedTitle" : attributedTitle, "attributedMessage" : attributedMessage])
        
        if let theActions = actions {
            for anAction in theActions {
                let action = UIAlertAction(title: anAction.0, style: .default) { alertAction in
                    anAction.1()
                }
                
                action.setValue(UIColor.darkText, forKey: "titleTextColor")
                alertViewController.addAction(action)
            }
        } else {
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            dismissAction.setValue(UIColor.darkText, forKey: "titleTextColor")
            alertViewController.addAction(dismissAction)
        }
        
        viewController.present(alertViewController, animated: true)
    }
    
}
