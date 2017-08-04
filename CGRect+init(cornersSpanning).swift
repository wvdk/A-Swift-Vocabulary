//
//  CGRect+init(cornersSpanning).swift
//  https://github.com/wvdk/A-Swift-Vocabulary
//
//  Created by Wesley Van der Klomp on 8/4/17.
//

import CoreGraphics

extension CGRect {
    
    /// Creates a rectangle with corners reaching from one point to another.
    init(cornersSpanning from: CGPoint, to: CGPoint) {
        let width =  to.x - from.x
        let height =  to.y - from.y
        
        self.init(x: from.x, y: from.y, width: width, height: height)
    }
    
}
