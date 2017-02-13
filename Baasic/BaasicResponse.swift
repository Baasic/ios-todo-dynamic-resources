//
//  BaasicResponse.swift
//  Baasic
//
//  Created by Zeljko Huber on 01/02/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

public enum BaasicResponse<T> {
    case success(T)
    case failure(Error, Int?)
}
