//
//  Post.swift
//  Baasic
//
//  Created by Zeljko Huber on 26/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import ObjectMapper

public class TodoModel : DynamicModelBase {
    public var title: String = ""
    public var description: String = ""
    public var isComplete: Bool = false
    public var dateCreated: Date = Date()
    
    required public init() {
        super.init()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        description <- map["description"]
        isComplete <- map["isComplete"]
        dateCreated <- (map["dateCreated"], DateFormatTransform())
    }

    public override class var schemaName: String {
        return "todo"
    }
    
    public func toJSON() -> [String : Any] {
        var dateCreatedString = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
        dateCreatedString = formatter.string(from: self.dateCreated)
        
        return [
            "title" : self.title,
            "description" : self.description,
            "isComplete" : String(self.isComplete),
            "dateCreated" : dateCreatedString
        ]
    }
}

public class DateFormatTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    var dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        self.dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
    }
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormatter.dateFormat = dateFormat
    }
    
    public func transformFromJSON(_ value: Any?) -> Object? {
        if let dateString = value as? String {
            return self.dateFormatter.date(from: dateString)
        }
        return nil
    }
    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return self.dateFormatter.string(from: date)
        }
        return nil
    }
}
