//
//  ViewControllerBase.swift
//  Baasic
//
//  Created by Zeljko Huber on 31/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import UIKit

public class ViewControllerBase : UIViewController {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func displayErrorMessage(errorType: ErrorType) {
        var alertData: (title: String, description: String)
        
        switch errorType {
            
        case .custom(title: let title, description: let description):
            alertData.title = title
            alertData.description = description
            break
        case .response(_ , _):
            alertData.title = "Request Error"
            alertData.description = "Something went wrong while processing your request. Please contact support team."
            break
            
        }
        
        let alertController = UIAlertController(title: alertData.title,
                                                message: alertData.description,
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

public enum ErrorType {
    case response(Error, Int?)
    case custom(title: String, description: String)
}
