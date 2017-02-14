//
//  DynamicResourceClient.swift
//  Baasic-SDK
//
//  Created by Zeljko Huber on 18/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

public class DynamicResourceClient<T : DynamicModel> : DynamicResourceRequestable {
    
    private let moduleRelativePath = "resources"
    
    private let sessionManager: SessionManager
    private let configuration: BaasicConfigurable
    
    init(sessionManager: SessionManager = SessionManager.default,
         configuration: BaasicConfigurable = BaasicConfiguration(applicationIdentifier: "todo"))
    {
        self.sessionManager = sessionManager
        self.configuration = configuration
    }
 
    public func delete(id: String, completion: @escaping (BaasicResponse<Bool>) -> Void) {
        let url = self.getDynamicResourceApiUrl(T.schemaName, id: id)
        
        self.sessionManager.request(url, method: .delete)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                    break
                case .failure(let error):
                    completion(.failure(error, response.response?.statusCode))
                    break
                }
            }
    }
    
    public func find(filter: ResourceFilterable, completion: @escaping (BaasicResponse<CollectionModelBase<T>>) -> Void) {
        self.find(schemaName: T.schemaName, filter: filter, completion: completion)
    }
    
    public func find(schemaName: String, filter: ResourceFilterable, completion: @escaping (BaasicResponse<CollectionModelBase<T>>) -> Void) {
        let url = self.getDynamicResourceApiUrl(schemaName)
        let parameters = filter.getQueryParameters()
        
        self.sessionManager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate()
            .responseObject { (response: DataResponse<CollectionModelBase<T>>) in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                    break
                case .failure(let error):
                    completion(.failure(error, response.response?.statusCode))
                    break
                }
            }
    }
    
    public func get(id: String, embed: String, fields: String, completion: @escaping (BaasicResponse<T>) -> Void) {
        self.get(schemaName: T.schemaName, id: id, fields: fields, completion: completion)
    }
    
    public func get(schemaName: String, id: String, fields: String, completion: @escaping (BaasicResponse<T>) -> Void) {
        let url = self.getDynamicResourceApiUrl(T.schemaName, id: id)
        
        self.sessionManager.request(url, method: .get)
            .validate()
            .responseObject(completionHandler: { (response: DataResponse<T>) in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                    break
                case .failure(let error):
                    completion(.failure(error, response.response?.statusCode))
                    break
                }
            })
    }
    
    public func update(resource: T, completion: @escaping (BaasicResponse<Bool>) -> Void) {
        self.update(schemaName: T.schemaName, resource: resource, completion: completion)
    }
    
    public func update(schemaName: String, resource: T, completion: @escaping (BaasicResponse<Bool>) -> Void) {
        let url = self.getDynamicResourceApiUrl(T.schemaName, id: resource.id)
        
        let json = resource.toJSON()
        
        self.sessionManager.request(url, method: .put, parameters: json, encoding: JSONEncoding.default)
            .validate()
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(_):
                    completion(.success(true))
                    break
                case .failure(let error):
                    completion(.failure(error, response.response?.statusCode))
                    break
                }
            })
    }
    
    public func insert(resource: T, completion: @escaping (BaasicResponse<T>) -> Void) {
        self.insert(schemaName: T.schemaName, resource: resource, completion: completion)
    }
    
    public func insert(schemaName: String, resource: T, completion: @escaping (BaasicResponse<T>) -> Void) {
        let url = self.getDynamicResourceApiUrl(schemaName)
        let json = resource.toJSON()
        
        self.sessionManager.request(url, method: .post, parameters: json, encoding: JSONEncoding.default)
            .validate()
            .responseObject(completionHandler: { (response: DataResponse<T>) in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                    break
                case .failure(let error):
                    completion(.failure(error, response.response?.statusCode))
                    break
                }
            })
    }
    
    private func getDynamicResourceApiUrl(_ schemaName: String, id: String) -> String {
        let url = self.getApiUrl(ssl: true, relativeUrl: "\(moduleRelativePath)/\(schemaName)/")
        return url + id
    }
    
    private func getDynamicResourceApiUrl(_ schemaName: String) -> String {
        return self.getDynamicResourceApiUrl(schemaName, id: "")
    }
    
    private func getApiUrl(relativeUrl: String) -> String {
        return getApiUrl(ssl: true, relativeUrl: relativeUrl)
    }
    
    private func getApiUrl(ssl: Bool, relativeUrl: String) -> String {
        let baseAddress = ssl ? self.configuration.secureBaseAddress.trimEnd("/") : self.configuration.baseAddress.trimEnd("/")
        let relative = self.configuration.applicationIdentifier.trimEnd("/") + "/" + relativeUrl
        return baseAddress + "/" + relative
    }
}
