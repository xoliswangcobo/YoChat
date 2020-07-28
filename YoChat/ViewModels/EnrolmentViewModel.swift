//
//  EnrolmentViewModel.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/27.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Bond

class EnrolmentViewModel {
    
    enum EnrolmentStatus {
        case Failed(Error,OperationState)
        case Success(String,OperationState)
        case Ignored
    }
    
    enum OperationState {
        case Enrol(message:String)
        case UnEnrol(message:String)
        case Update(message:String)
        case None
    }
    
    var loadingOperationState = Observable<OperationState>(.None)
    var messageEnrolmentStatus = Observable<EnrolmentStatus>(.Ignored)
    
    let firstname: Observable<String?> = Observable<String?>("")
    let lastname: Observable<String?> = Observable<String?>("")
    let alias: Observable<String?> = Observable<String?>("")
    let email: Observable<String?> = Observable<String?>("")
    let serverIPURL: Observable<String?> = Observable<String?>("http://localhost:5555")
    
    func enrolUser() {
        AppContainer.shared.messagingURL = self.serverIPURL.value?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.loadingOperationState.send(.Enrol(message: "Enrolling..."))
        
        let details:[String:Any] = [
            "email" : self.email.value?.trimmingCharacters(in: .whitespacesAndNewlines) as Any,
            "firstname" : self.firstname.value?.trimmingCharacters(in: .whitespacesAndNewlines) as Any,
            "lastname" : self.lastname.value?.trimmingCharacters(in: .whitespacesAndNewlines) as Any,
            "alias" : self.alias.value?.trimmingCharacters(in: .whitespacesAndNewlines) as Any
        ]
        
        do {
            let user:User? = try User.decode(details)
            AppContainer.shared.currentUser = user
            self.messageEnrolmentStatus.send(.Success("Successfully enrolled", .Enrol(message: "")))
        } catch let error {
            self.messageEnrolmentStatus.send(.Failed(error, .Enrol(message: "")))
        }
    }
    
    func unEnrol() {
        
    }
    
    func update() {
        
    }
    
    func validate() -> Bool {
        guard let email = self.email.value?.trimmingCharacters(in: .whitespacesAndNewlines), let firstname = self.firstname.value?.trimmingCharacters(in: .whitespacesAndNewlines), let lastname = self.lastname.value?.trimmingCharacters(in: .whitespacesAndNewlines), let alias = self.alias.value?.trimmingCharacters(in: .whitespacesAndNewlines), let serverIPURL = self.serverIPURL.value?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return false
        }

        return (email.isValidEmail() && (firstname.isEmpty == false) && (lastname.isEmpty == false) && (alias.isEmpty == false) && (serverIPURL.isEmpty == false))
    }
}
