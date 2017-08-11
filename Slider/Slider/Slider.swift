//
//  Slider.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/9/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation
import SpriteKit

/// A user interface which the user can select and drag a knob to change a value.
class Slider {
    
    /// A SliderNode (subclass of SKShapeNode) for adding to a SpriteKit scene.
    ///
    /// Things like position, size, or color are all updated automatically when you change the properties of a `Slider` instance. So you should rarely need to set properties of this `node` property directly.
    let node: SliderNode
    
    /// The position of the slider in it's parents coordinate system.
    var position = CGPoint(x: 0, y: 0) {
        didSet {
            node.position = position
        }
    }
 
    /// The size of the slider.
    var size = CGSize(width: 300, height: 100) {
        didSet {
             // TODO: update the nodes with new size
        }
    }
    
    /// The value of the slider, which is changed by dragging the knob: Ranges from 0.0 to 1.0.
    var value: Double {
        return Double(knob.position.x / size.width)
    }
    
    /// Calculated center point of the slider.
    private var center: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    private let knob = SliderKnob()
    
    private let track = SliderTrack()
    
    private typealias ValueChangeHandler = (Double) -> ()
    
    private var valueChangeHandlers: [ValueChangeHandler] = []
    
    /// Creates a Slider which containts a knob and track.
    init() {
        node = SliderNode(rect: CGRect(origin: position, size: size))
        
        node.lineWidth = 0.0
        
        knob.position = center
        track.position = center
        
        track.size = CGSize(width: self.size.width, height: 10)
        
        node.isUserInteractionEnabled = true
        node.owner = self
        
        node.addChild(track.node)
        node.addChild(knob.node)
    }
    
    /// Handles when the user clicks on the slider. Called from `SliderNode`.
    func click(at point: CGPoint) {
        moveKnob(to: point)
    }
    
    /// Handles when the user drags mouse on the slider. Called from `SliderNode`.
    func dragging(currentPoint: CGPoint) {
        moveKnob(to: currentPoint)
    }
    
    /// Handles all movement of knob.
    func moveKnob(to point: CGPoint) {
        let oldY = knob.position.y
        var newX = point.x
        let knobRadius = knob.radius
        
        // Constrain knob to stay inside of slider's bounds
        if newX < (0 + knobRadius) {
            newX = 0 + knobRadius
        } else if newX > (size.width - knobRadius) {
            newX = size.width - knobRadius
        }
        
        knob.position = CGPoint(x: newX, y: oldY)
        
        for handler in valueChangeHandlers {
            handler(value)
        }
        
        // TESTING:
        print("Slider value: \(value)")
    }
    
    /// ...
    func addValueChangeHandler(handler: @escaping (Double) -> ()) {
        valueChangeHandlers.append(handler)
    }
    
}
