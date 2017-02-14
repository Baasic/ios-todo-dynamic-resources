//
//  StringExtensions.swift
//  Baasic
//
//  Created by Zeljko Huber on 23/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

extension String {
    func trimEnd(_ value: Character) -> String {
        if let last = self.characters.last, last == value {
            return self.substring(to: self.index(before: self.endIndex))
        }
        
        return self
    }
}
