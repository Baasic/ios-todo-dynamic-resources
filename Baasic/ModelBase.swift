//
//  ModelBase.swift
//  Baasic
//
//  Created by Zeljko Huber on 23/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol DynamicModel : ResponseSerializable {
    init()
    
    var id: String { get set }
    
    static var schemaName: String { get }
}

public class DynamicModelBase : DynamicModel {
    
    public var id: String = ""
    
    public required init() {
        
    }
    
    required public init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        id <- map["id"]
    }
    
    public class var schemaName: String {
        fatalError("override in subclass")
    }
}
