//
//  LoadingView.swift
//  YoChat
//
//  Created by Xoliswa on 2020/07/25.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private static var viewControllerWindow: UIWindow?
    private static var loadingIndicatorView: LoadingView?
    
    func isShowing() -> Bool {
        return LoadingView.loadingIndicatorView != nil || LoadingView.viewControllerWindow != nil
    }
    
    class func show(on viewController:UIViewController, loadingMessage:String = "Please wait...") {
        self.viewControllerWindow = viewController.view.window
        self.viewControllerWindow?.isUserInteractionEnabled = false
        
        var containerView: UIView
        var progressIndicator:UIActivityIndicatorView
        var loadingIndicatorViewMessage:UILabel
        
        if (self.loadingIndicatorView != nil) {
            self.loadingIndicatorView?.removeFromSuperview()
            self.loadingIndicatorView = nil
        }
        
        self.loadingIndicatorView = LoadingView.init(frame: self.viewControllerWindow!.frame)
        self.loadingIndicatorView?.backgroundColor = .clear
        
        containerView = UIView.init(frame: CGRect(x: 0, y: 0, width: loadingIndicatorView!.frame.size.width*0.6, height: loadingIndicatorView!.frame.size.height*0.2))
        containerView.backgroundColor = .lightText
        containerView.layer.cornerRadius = 5.0
        containerView.center = CGPoint(x: loadingIndicatorView!.center.x, y: loadingIndicatorView!.center.y)
        
        progressIndicator = .init(style: UIActivityIndicatorView.Style.medium)
        progressIndicator.center = CGPoint(x: containerView.frame.size.width / 2, y: containerView.frame.size.height / 3);
        progressIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5);
        progressIndicator.color = .orange
        progressIndicator.startAnimating()
        
        loadingIndicatorViewMessage = UILabel.init(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height*0.3))
        loadingIndicatorViewMessage.attributedText = NSAttributedString.init(string: loadingMessage, attributes: [ .foregroundColor : UIColor.darkText])
        loadingIndicatorViewMessage.textAlignment = .center
        loadingIndicatorViewMessage.center = CGPoint(x: progressIndicator.center.x, y: (containerView.frame.size.height / 3) * 2)
        
        self.loadingIndicatorView!.addSubview(containerView)
        containerView.addSubview(loadingIndicatorViewMessage)
        containerView.addSubview(progressIndicator)
        
        LoadingView.viewControllerWindow?.addSubview(self.loadingIndicatorView!)
    }
    
    class func dismiss() {
        self.viewControllerWindow?.isUserInteractionEnabled = true
        self.viewControllerWindow?.alpha = 1.0
        self.viewControllerWindow = nil
        self.loadingIndicatorView?.removeFromSuperview()
        self.loadingIndicatorView = nil
    }
}
