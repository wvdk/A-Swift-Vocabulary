//
//  DictionaryExtensions.swift
//

import UIKit

public extension Dictionary {

    public static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
    
    public static func + (left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
        var new: [Key: Value] = [:]

        for (key, value) in right {
            new[key] = value
        }
        
        for (key, value) in left {
            new[key] = value
        }
        
        return new
    }

}

