//
//  CGRect+init(cornersSpanning).swift
//  DragLeft
//
//  Created by Wesley Van der Klomp on 8/4/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import CoreGraphics

extension CGRect {
    
    /// Creates a rectangle with corners reaching from `pointA` to `pointB`.
    init(cornersSpanning from: CGPoint, to: CGPoint) {
        let width =  to.x - from.x
        let height =  to.y - from.y
        
        self.init(x: from.x, y: from.y, width: width, height: height)
    }
    
}
