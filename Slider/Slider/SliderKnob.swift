//
//  SliderKnob.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/8/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Cocoa
import SpriteKit

/// The part of a slider than the user clicks on and drags in order to change the value.
class SliderKnob {
    
    /// An SKShapeNode for adding to a SpriteKit scene.
    ///
    /// Things like position, size, or color are all updated automatically when you change the properties of a `SliderKnob` instance. So you should rarely need to set properties of this `node` property directly.
    var node: SKShapeNode
    
    /// The position of the knob in it's parents coordinate system. Also used to calculate the slider's value.
    var position: CGPoint {
        didSet {
            node.position = position
        }
    }
    
    /// The radius of the knob.
    var radius = CGFloat(20) {
        didSet {
            node = SKShapeNode(circleOfRadius: radius)
        }
    }
    
    /// Creates a knob at `position`.
    init(position: CGPoint) {
        self.position = position
        
        node = SKShapeNode(circleOfRadius: radius)
        
        node.fillColor = SKColor.white
        node.strokeColor = SKColor.gray
        node.lineWidth = 1.5
        node.position = position
    }
    
    /// Creates a knob at `position` of (0, 0).
    convenience init() {
        self.init(position: CGPoint(x: 0, y: 0))
    }
    
}
