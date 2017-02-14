//
//  ResourceFilterable.swift
//  Baasic
//
//  Created by Zeljko Huber on 14/02/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public protocol ResourceFilterable {
    var searchQuery: String { get set }
    var page: Int { get set }
    var rpp: Int { get set }
    var sort: String { get set }
    var embed: String { get set }
    var fields: String { get set }
    
    func getQueryParameters() -> [String: Any]
}
