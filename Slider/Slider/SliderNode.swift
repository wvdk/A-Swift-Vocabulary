//
//  SliderNode.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/10/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation
import SpriteKit

/// A SKShapeNode subclass for handling user interaction and passing that event info to `owner`.
class SliderNode: SKShapeNode {

    /// A reverence to the object that owns this object.
    var owner: Slider? = nil

    // MARK: NSResponder methods

    override func mouseDown(with event: NSEvent) {
        if let owner = owner {
            owner.click(at: event.location(in: owner.node))
        }
    }

    override func mouseDragged(with event: NSEvent) {
        if let owner = owner {
            owner.dragging(currentPoint: event.location(in: owner.node))
        }
    }

}

