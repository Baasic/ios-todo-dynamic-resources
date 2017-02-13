//
//  BaasicConfiguration.swift
//  Baasic
//
//  Created by Zeljko Huber on 23/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public class BaasicConfiguration : BaasicConfigurable {
    private let MediaTypeHalJson = "application/hal+json"
    private let MediaTypeJson = "application/json"
    private let DefaultTimeout = 30.0
    private let DefaultEncoding = String.Encoding.utf8
    
    public var applicationIdentifier: String
    public var baseAddress: String
    public var secureBaseAddress: String
    public var defaultMediaType: String
    public var defaultEncoding: String.Encoding
    public var defaultTimeout: TimeInterval
    
    convenience init(applicationIdentifier: String) {
        let baasicBaseAddress = "http://api.baasic.com/"
        let baasicVersion = "v1"
        
        let baseAddress = baasicBaseAddress + baasicVersion
        self.init(baseAddress, applicationIdentifier: applicationIdentifier)
    }
    
    init(_ baseAddress: String, applicationIdentifier: String) {
        self.baseAddress = baseAddress
        self.applicationIdentifier = applicationIdentifier
        self.secureBaseAddress = self.baseAddress.replacingOccurrences(of: "http://", with: "https://")
        self.defaultEncoding = DefaultEncoding
        self.defaultTimeout = DefaultTimeout
        self.defaultMediaType = MediaTypeHalJson
    }
}
