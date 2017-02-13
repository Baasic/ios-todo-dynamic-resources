//
//  ResponseSerializable.swift
//  Baasic
//
//  Created by Zeljko Huber on 22/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ResponseSerializable : Mappable {
    init()
}
