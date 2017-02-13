//
//  NibViewProtocol.swift
//  AnesthesiaScheduler
//
//  Created by ASMono on 14/01/16.
//  Copyright © 2016 Mono. All rights reserved.
//

import UIKit

public typealias NibReusable = Reusable & NibLoadable

public protocol NibLoadable : class {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibLoadable where Self : UIView {
    
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    
    /// Use this method if the XIB you're using don't use its "File's Owner" and
    /// the reusable view you're designing is the root view of the XIB
    ///
    /// - Returns: 'Self'
    public static func loadFromNib() -> Self {
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
    
    /// Use this method if you used a "File's Owner" of the XIB being of the class of your reusable view, 
    /// and the root view(s) of the XIB is to be set as a subview providing its content.
    ///
    /// - Parameter owner: Owner of the nib
    /// - Returns: 'Self'
    @discardableResult
    public static func loadFromNib(owner: Self = Self()) -> Self {
        let layoutAttributes: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing]
        for view in nib.instantiate(withOwner: owner, options: nil) {
            if let view = view as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
                owner.addSubview(view)
                layoutAttributes.forEach { attribute in
                    owner.addConstraint(NSLayoutConstraint(item: view,
                                                           attribute: attribute,
                                                           relatedBy: .equal,
                                                           toItem: owner,
                                                           attribute: attribute,
                                                           multiplier: 1,
                                                           constant: 0.0))
                }
            }
        }
        return owner
    }
    
    public var nibName: String {
        return String(describing: type(of: self))
    }
    
    private func loadFromNib(owner: UIView) -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        return nib.instantiate(withOwner: owner, options: nil)[0] as! UIView
    }
    
    public func setupNib(owner: UIView) {
        let view = self.loadFromNib(owner: owner)
        view.translatesAutoresizingMaskIntoConstraints = false
        owner.addSubview(view)
        
        let layoutAttributes: [NSLayoutAttribute] = [.top, .leading, .bottom, .trailing]
        layoutAttributes.forEach { attribute in
            owner.addConstraint(NSLayoutConstraint(item: view,
                                                   attribute: attribute,
                                                   relatedBy: .equal,
                                                   toItem: owner,
                                                   attribute: attribute,
                                                   multiplier: 1,
                                                   constant: 0.0))
        }
    }
}
