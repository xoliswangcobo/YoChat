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
    let serverIP: Observable<String?> = Observable<String?>("")
    
    func enrolUser() {
        
    }
    
    func unEnrol() {
        
    }
    
    func update() {
        
    }
}
