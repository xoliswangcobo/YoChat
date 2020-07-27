//
//  AddChatViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/27.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import MaterialComponents
import Bond
import ReactiveKit

class AddChatViewController: KeyboardManagedViewController {

    var completionHandler:((ChatContact?) -> Void)?
    
    @IBOutlet weak var firstname:MDCOutlinedTextField!
    @IBOutlet weak var lastname:MDCOutlinedTextField!
    @IBOutlet weak var alias:MDCOutlinedTextField!
    @IBOutlet weak var email:MDCOutlinedTextField!
    @IBOutlet weak var addButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        self.setupBinding()
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true) {}
    }
    
    func setupBinding() {
        combineLatest(self.firstname.reactive.text, self.lastname.reactive.text) { firstname, lastname in
            return self.validate()
        }.bind(to: self.addButton.reactive.isEnabled)
        
        combineLatest(self.email.reactive.text, self.alias.reactive.text) { email, alias in
            return self.validate()
        }.bind(to: self.addButton.reactive.isEnabled)
        
        let _ = self.addButton.reactive.tap.observe { _ in
            guard let email = self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines), let firstname = self.firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines), let lastname = self.lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines), let alias = self.alias.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                self.completionHandler?(nil)
                return
            }
            
            let details:[String:Any] = [
                "email" : email,
                "firstname" : firstname,
                "lastname" : lastname,
                "alias" : alias
            ]
            
            do {
                let contact:ChatContact? = try ChatContact.decode(details)
                self.completionHandler?(contact)
            } catch {
                self.completionHandler?(nil)
            }
        }.dispose(in: self.reactive.bag)
    }
    
    private func validate() -> Bool {
        guard let email = self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines), let firstname = self.firstname.text?.trimmingCharacters(in: .whitespacesAndNewlines), let lastname = self.lastname.text?.trimmingCharacters(in: .whitespacesAndNewlines), let alias = self.alias.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }

        return (email.isValidEmail() && (firstname.isEmpty == false) && (lastname.isEmpty == false) && (alias.isEmpty == false))
    }

}
