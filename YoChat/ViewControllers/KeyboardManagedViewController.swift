//
//  KeyboardManagedViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/26.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class KeyboardManagedViewController: UIViewController {

    @IBOutlet weak var constraintBottom:NSLayoutConstraint?
    var dimissKeyBoardTapGesture:UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc func keyboardWillShow(notification:Notification) {
        let info = notification.userInfo
        let rect = info?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let kbSize:CGSize = rect.size

        self.constraintBottom?.constant = kbSize.height
        self.view.layoutIfNeeded()
        
        for gestureRecognizer in self.view?.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(gestureRecognizer)
        }
        
        self.dimissKeyBoardTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(self.dimissKeyBoardTapGesture!)
    }
    
    @objc func keyboardWillHide(notification:Notification) {
    
        self.constraintBottom?.constant = 0
        self.view.layoutIfNeeded()
        
        for gestureRecognizer in self.view?.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(gestureRecognizer)
        }
        
        if self.dimissKeyBoardTapGesture != nil {
            self.dimissKeyBoardTapGesture = nil
        }
    }
}
