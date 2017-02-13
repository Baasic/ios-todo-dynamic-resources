//
//  AlamofireArraySerialization.swift
//  Baasic
//
//  Created by Zeljko Huber on 22/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension DataRequest {
    
    /// Custom error codes for object/array response serialization
    ///
    /// - dataSerializationFailed: Defines data response serialization failure.
    enum ErrorCode: Int {
        case dataSerializationFailed = 1
    }
    
    
    /// Creates new error from error code and failure reason.
    ///
    /// - Parameters:
    ///   - code: Error code that defines failure reason type.
    ///   - failureReason: Defines failure reason.
    ///
    /// - Returns: Instance of 'NSError'
    internal static func createError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.alamofireSerialization.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    
    /// Adds a handler for object serialization to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - queue:             The queue on which the completion handler is dispatched.
    ///   - completionHandler: Completion handler to be executed once the request has finished.
    ///
    /// - Returns: 'DataRequest' instance.
    @discardableResult
    public func responseObject<T: ResponseSerializable>(
            queue: DispatchQueue? = nil,
            completionHandler: @escaping (DataResponse<T>) -> Void
        ) -> Self
    {
        let serializer: DataResponseSerializer<T> = DataRequest.objectResponseSerializer()
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }
    
    
    /// Adds a handler for object array serialization to be called once the request has finished.
    ///
    /// - Parameters:
    ///   - queue:             The queue on which the completion handler is dispatched.
    ///   - completionHandler: Completion handler to be executed once the request has finished.
    ///
    /// - Returns: 'DataRequest' instance.
    @discardableResult
    public func responseArray<T: ResponseSerializable>(
            queue: DispatchQueue? = nil,
            completionHandler: @escaping (DataResponse<[T]>) -> Void
        ) -> Self
    {
        let serializer: DataResponseSerializer<[T]> = DataRequest.arrayResponseSerializer()
        return response(queue: queue, responseSerializer: serializer, completionHandler: completionHandler)
    }

    
    /// Creates a object response serializer.
    ///
    /// - Parameters:
    ///   - readingOptions: Reading options that defines 'data' to 'jsonObject' serialization.
    ///
    /// - Returns: 'DataResponseSerializer<T>' instance.
    public static func objectResponseSerializer<T: ResponseSerializable>(
            readingOptions: JSONSerialization.ReadingOptions = .allowFragments
        ) -> DataResponseSerializer<T>
    {
        return DataResponseSerializer { (request, response, data, error) in
            guard error == nil else {
                return .failure(error!)
            }
            
            if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(T()) }
            
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            let JSONToMap: Any
            
            do {
                JSONToMap = try JSONSerialization.jsonObject(with: validData, options: readingOptions)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
            
            guard let parsedObject = Mapper<T>().map(JSONObject: JSONToMap) else {
                let error = createError(.dataSerializationFailed, failureReason: "Data could not be mapped as T")
                return .failure(error)
            }
            
            return .success(parsedObject)
        }
    }
    
    
    /// Creates a object array response serializer.
    ///
    /// - Parameters:
    ///   - readingOptions: Reading options that defines 'data' to 'jsonObject' serialization.
    ///
    /// - Returns: 'DataResponseSerializer<[T]>' instance.
    public static func arrayResponseSerializer<T: ResponseSerializable>(
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments
        ) -> DataResponseSerializer<[T]>
    {
        return DataResponseSerializer { (request, response, data, error) in
            guard error == nil else {
                return .failure(error!)
            }
            
            if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success([T]()) }
            
            guard let validData = data, validData.count > 0 else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            
            let JSONToMap: Any
            
            do {
                JSONToMap = try JSONSerialization.jsonObject(with: validData, options: readingOptions)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
            
            guard let parsedObject = Mapper<T>().mapArray(JSONObject: JSONToMap) else {
                let error = createError(.dataSerializationFailed, failureReason: "Data could not be mapped as array of T")
                return .failure(error)
            }
            
            return .success(parsedObject)
        }
    }
    
}
