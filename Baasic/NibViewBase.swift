//
//  NibView.swift
//  AnesthesiaScheduler
//
//  Created by ASMono on 14/01/16.
//  Copyright © 2016 Mono. All rights reserved.
//

import UIKit

public class NibViewBase: UIView, NibLoadable {
    
    // MARK: - Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(owner: self)
    }
    
    // MARK: - NSCoding
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNib(owner: self)
    }
}
