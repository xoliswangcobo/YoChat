//
//  UIApplication.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//
// https://github.com/ogulcan/iOS-Login-Example

import UIKit

extension UIApplication {
    
    static var loginAnimation: UIView.AnimationOptions = .transitionFlipFromRight
    static var logoutAnimation: UIView.AnimationOptions = .transitionFlipFromLeft
    
    public static func setRootView(_ viewController: UIViewController,
                                   options: UIView.AnimationOptions = .transitionFlipFromRight,
                                   animated: Bool = true,
                                   duration: TimeInterval = 0.5,
                                   completion: (() -> Void)? = nil) {
        guard animated else {
             UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController
            return
        }
        
        UIView.transition(with:  UIApplication.shared.windows.first { $0.isKeyWindow }!, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
             UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
}
