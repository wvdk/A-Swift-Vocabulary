//
//  ArrayExtensions.swift
//

import Foundation

extension Array {
    
    func randomItem() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))
        return self[randomIndex]
    }
    
}
