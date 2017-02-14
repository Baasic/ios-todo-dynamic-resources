//
//  Reusable.swift
//  Baasic
//
//  Created by Zeljko Huber on 28/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public protocol Reusable : class {
    /// Reuse identifier
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
