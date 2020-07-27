//
//  Container.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/26.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

class AppContainer {
    
    static let shared = AppContainer()
    
    let container = Container()
    var currentUser:User?
    
    private init() {
        setupDefaultContainers()
    }
    
    private func setupDefaultContainers() {
        container.register(ChatsViewModel.self) { resolver in
            return ChatsViewModel.init()
        }
    }
}

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.storyboardInitCompleted(ChatsViewController.self) { _, controller in
            controller.chatsViewModel = AppContainer.shared.container.resolve(ChatsViewModel.self)
        }
    
    }
}
