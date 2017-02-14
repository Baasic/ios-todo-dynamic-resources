//
//  CollectionModelBase.swift
//  Baasic
//
//  Created by Zeljko Huber on 23/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import ObjectMapper

public class CollectionModelBase<T: DynamicModel> : ResponseSerializable {
    public required init() {
        
    }
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map) {
        
    }
    
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    public func mapping(map: Map) {
        embed <- map["embed"]
        item <- map["item"]
        links <- map["links"]
        page <- map["page"]
        recordsPerPage <- map["recordsPerPage"]
        searchQuery <- map["searchQuery"]
        sort <- map["sort"]
        totalRecords <- map["totalRecords"]
    }
    
    public var embed: String = ""
    public var item: [T] = []
    public var links: [String]?
    public var page: Int = 0
    public var recordsPerPage: Int = 0
    public var searchQuery: String = ""
    public var sort: String = ""
    public var totalRecords: Int = 0
}
