//
//  DynamicResourceRequestable.swift
//  Baasic-SDK
//
//  Created by Zeljko Huber on 18/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public protocol DynamicResourceRequestable {
    associatedtype T : DynamicModel
    
    func delete(id: String, completion: @escaping (BaasicResponse<Bool>) -> Void)
    
    func find(filter: ResourceFilterable, completion: @escaping (BaasicResponse<CollectionModelBase<T>>) -> Void)
    
    func find(schemaName: String, filter: ResourceFilterable, completion: @escaping (BaasicResponse<CollectionModelBase<T>>) -> Void)
    
    func get(id: String, embed: String, fields: String, completion: @escaping (BaasicResponse<T>) -> Void)
    
    func get(schemaName: String, id: String, fields: String, completion: @escaping (BaasicResponse<T>) -> Void)
    
    func insert(resource: T, completion: @escaping (BaasicResponse<T>) -> Void)
    
    func insert(schemaName: String, resource: T, completion: @escaping (BaasicResponse<T>) -> Void)
    
    func update(resource: T, completion: @escaping (BaasicResponse<Bool>) -> Void)
    
    func update(schemaName: String, resource: T, completion: @escaping (BaasicResponse<Bool>) -> Void)
}
