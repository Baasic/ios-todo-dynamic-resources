//
//  LoaderView.swift
//  Baasic
//
//  Created by Zeljko Huber on 28/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import UIKit

class LoaderView: NibViewBase {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    public var isLoading = false
    
    public class var sharedInstance: LoaderView {
        struct Singleton {
            static let instance = LoaderView(frame: CGRect.zero)
        }
        return Singleton.instance
    }
    
    // Methods
    public class func show() {
        let loader = LoaderView.sharedInstance
        loader.isLoading = true
        loader.updateFrame()
        
        if loader.superview == nil {
            UIApplication.shared.keyWindow?.addSubview(loader)
            
            // Update frame on rotation
            NotificationCenter.default.addObserver(loader,
                                                   selector: #selector(updateFrame),
                                                   name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation,
                                                   object: nil)
        }
    }
    
    public class func hide() {
        let loader = LoaderView.sharedInstance
        loader.isLoading = false
        NotificationCenter.default.removeObserver(loader)
        
        DispatchQueue.main.async(execute: {
            if loader.superview == nil {
                return
            }
            
            loader.removeFromSuperview()
        })
    }
    
    public func updateFrame() {
        let window = UIApplication.shared.windows.first!
        self.frame = window.frame
    }
}
