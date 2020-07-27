//
//  EnrolmentViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/27.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import MaterialComponents

class EnrolmentViewController: KeyboardManagedViewController {

    var enrolmentViewModel: EnrolmentViewModel!
    
    @IBOutlet weak var firstname:MDCOutlinedTextField!
    @IBOutlet weak var lastname:MDCOutlinedTextField!
    @IBOutlet weak var alias:MDCOutlinedTextField!
    @IBOutlet weak var email:MDCOutlinedTextField!
    @IBOutlet weak var serverIPURL:MDCOutlinedTextField!
    @IBOutlet weak var enrolButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
        self.firstname.sizeToFit()
    }
    
    func setupBinding() {
        self.enrolmentViewModel.firstname.bidirectionalBind(to: self.firstname.reactive.text)
        self.enrolmentViewModel.lastname.bidirectionalBind(to: self.lastname.reactive.text)
        self.enrolmentViewModel.alias.bidirectionalBind(to: self.alias.reactive.text)
        self.enrolmentViewModel.email.bidirectionalBind(to: self.email.reactive.text)
        self.enrolmentViewModel.serverIPURL.bidirectionalBind(to: self.serverIPURL.reactive.text)
        
        let _ = self.enrolmentViewModel.loadingOperationState.observeNext { [unowned self] (state) in
            switch state {
                case .Enrol(let message):
                    LoadingView.show(on: self, loadingMessage: message)
                default:
                    LoadingView.dismiss()
            }
        }.dispose(in: self.reactive.bag)
        
        let _ = self.enrolmentViewModel.messageEnrolmentStatus.observeNext { [unowned self] (status) in
            LoadingView.dismiss()
            switch status {
                case .Failed(let error, _):
                    MessageView.showMessage(title: "Enrolment", message: error.localizedDescription, viewController: self, actions: [("Okay", {})])
                case .Success(_, let operation):
                    switch operation {
                        case .Enrol(_):
                            let navigationController = self.storyboard?.instantiateViewController(identifier: "MainNavigationController") as! UINavigationController
                            UIApplication.setRootView(navigationController, options: .transitionCrossDissolve)
                        default:
                        break
                    }
                case .Ignored:
                    break
            }
        }.dispose(in: self.reactive.bag)
        
        self.setupComboBinding()
        
        let _ = self.enrolButton.reactive.tap.observe {_ in
            self.enrolmentViewModel.enrolUser()
        }.dispose(in: self.reactive.bag)
    }

    func setupComboBinding() {
        combineLatest(self.firstname.reactive.text, self.lastname.reactive.text, self.alias.reactive.text) { firstname, lastname, alias in
            return self.enrolmentViewModel.validate()
        }.bind(to: self.enrolButton.reactive.isEnabled)
        
        combineLatest(self.email.reactive.text, self.serverIPURL.reactive.text) { email, serverIPURL in
            return self.enrolmentViewModel.validate()
        }.bind(to: self.enrolButton.reactive.isEnabled)
    }
    
}
