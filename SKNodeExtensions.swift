//
//  SKNodeExtensions.swift
//
//  Created by Wesley Van der Klomp on 12/29/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    /// Returns a new frame with padding on the top, right, left, bottom by half of the `node`'s  respective height/width.
    func paddedFrame(for node: SKNode) -> CGRect {
        let paddedFrame = CGRect(x: self.frame.minX - (node.frame.width / 2),
                                 y: self.frame.minY - (node.frame.height / 2),
                                 width: self.frame.width + node.frame.width,
                                 height: self.frame.height + node.frame.height)
        
        return paddedFrame
    }
    
    /// Removes any children who's bounds are out of frame.
    func removeAnyOutOfFrameChildren() {
        for child in self.children {
            if !self.paddedFrame(for: child).contains(child.position) {
                child.removeFromParent()
            }
        }
    }
    
}
