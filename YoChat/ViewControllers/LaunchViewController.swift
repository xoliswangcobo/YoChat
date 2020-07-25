//
//  LaunchViewController.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            let navigationController = self.storyboard?.instantiateViewController(identifier: "MainNavigationController") as! UINavigationController
            UIApplication.setRootView(navigationController, options: .transitionCrossDissolve)
        }
    }
}
