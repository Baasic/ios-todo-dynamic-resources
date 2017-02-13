//
//  BaasicConfigurable.swift
//  Baasic
//
//  Created by Zeljko Huber on 23/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

/// Baasic configuration for baasic http client
public protocol BaasicConfigurable {
    
    /// Baasic application identifier
    var applicationIdentifier: String { get }
    
    /// Base address
    var baseAddress: String { get }
    
    /// Secure base address
    var secureBaseAddress: String { get }
    
    /// Default media type
    var defaultMediaType: String { get }
    
    /// Default timeout for requests
    var defaultTimeout: TimeInterval { get }
    
    /// Default encoding for requests
    var defaultEncoding: String.Encoding { get }
}
