//
//  FilterParameters.swift
//  Baasic
//
//  Created by Zeljko Huber on 30/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public class FilterParameters : ResourceFilterable {
    
    private let DefaultSearchQuery = ""
    private let DefaultPage = 1
    private let DefaultRpp = 10
    private let DefaultSort = ""
    private let DefaultEmbed = ""
    private let DefaultFields = ""
    
    public var searchQuery: String
    
    public var page: Int
    
    public var rpp: Int
    
    public var sort: String
    
    public var embed: String
    
    public var fields: String
    
    init() {
        self.searchQuery = DefaultSearchQuery
        self.page = DefaultPage
        self.rpp = DefaultRpp
        self.sort = DefaultSort
        self.embed = DefaultEmbed
        self.fields = DefaultFields
    }
    
    public func getQueryParameters() -> [String: Any] {
        var query: [String : Any] = [
            "page" : page,
            "rpp" : rpp,
            ]
        
        if searchQuery != DefaultSearchQuery {
            query["searchQuery"] = searchQuery
        }
        
        if sort != DefaultSort {
            query["sort"] = sort
        }
        
        if embed != DefaultEmbed {
            query["embed"] = embed
        }
        
        if fields != DefaultFields {
            query["fields"] = fields
        }
        
        return query
    }
}
