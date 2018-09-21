//
//  String+Initials.swift
//
//  Created by Austin Fitzpatrick on 5/2/18.
//

import Foundation

public extension String {

    public var initials:String {
        let nameToParse = self
        let components = nameToParse.components(separatedBy: " ")
        let initials:[String] = components.compactMap({
            if let char = $0.first {
                return String(char)
            } else {
                return nil
            }
        })
        if initials.count > 2 {
            return "\(initials[0])\(initials[1])"
        }
        return initials.joined()
    }
    
}
