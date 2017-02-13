//
//  StoryboardLoadable.swift
//  Baasic
//
//  Created by Zeljko Huber on 28/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import UIKit

public protocol StoryboardLoadable: class {
    
    static var storyboard: UIStoryboard { get }
    
    static var storyboardName: String { get }
    
    static var sceneIdentifier: String { get }
}

public extension StoryboardLoadable where Self : UIViewController {
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
    }
    
    static var sceneIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboardName: String {
        return String(describing: self)
    }
    
    static func loadFromStoryboard() -> Self {
        guard let vc = storyboard.instantiateViewController(withIdentifier: sceneIdentifier) as? Self else {
            fatalError("❗️Could not load controller from \(storyboardName).storyboard with identifier: \(sceneIdentifier)")
        }
        return vc
    }
    
}
