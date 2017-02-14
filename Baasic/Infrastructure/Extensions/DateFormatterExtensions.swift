//
//  DateFormatterExtensions.swift
//  Baasic
//
//  Created by Zeljko Huber on 14/02/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public static func todoDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        return formatter
    }
}
