//
//  TransformationGestureRecognizer.swift
//  Octi-app
//
//  Created by Austin Fitzpatrick on 10/4/18.
//  Copyright © 2018 Octi. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass


/// A TransformationGestureRecognizer handles one or more touches to create a Transform
/// struct which can be used to transform a UIView or any other object that can have
/// a translation, scale, and rotation applied.
public class TransformationGestureRecognizer: UIGestureRecognizer {
    
    /// The transform to start with.  This is useful if you want to continue transforming
    /// an object that is already transformed.
    public var startingTransform:Transform = .identity

    /// A combined transform struct containing the translation, rotation, and scale after having applied it to
    /// the starting transform.  This is the property that should be used to adjust the appearance of the view being
    /// manipulated
    var transform: Transform {
        
        return Transform(scale: startingTransform.scale * Float(scale), rotation: startingTransform.rotation + Float(rotation), translation: startingTransform.translation + translation)
    }
    
    //////
    /// Private properties to manage gesture reocngizer state
    private var lastNumberOfTouches: Int = 0
    private var touches: Set<UITouch> = []
    
    private var panOffset: CGPoint = .zero
    
    private var startingDistance: CGFloat?
    private var startingRotation: CGFloat?
    private var startingLocation: CGPoint?
    
    private var currentDistance: CGFloat?
    private var currentRotation: CGFloat?
    private var currentLocation: CGPoint?
    
    //////
    /// Useful calculated properties
    
    /// The translation (left, right, up, down movement of the fingers on the screen)
    private var translation: CGPoint {
        return (currentLocation ?? .zero) - (startingLocation ?? .zero)
    }
    
    /// The rotation (twisting motion of the fingers on the screen)
    private var rotation: CGFloat {
        return (currentRotation ?? 0) - (startingRotation ?? 0) + fingerLiftRotation
    }
    
    /// The scale (pinching or "zooming" motion on the screen)
    private var scale: CGFloat {
        return ((currentDistance ?? 1) / (startingDistance ?? 1)) * fingerLiftScale
    }
    
    // If the user lifts their second finger, lets remember
    // what our scale or rotation was to add it to the new one
    // if they decide to put their finger back down
    var fingerLiftRotation: CGFloat = 0
    var fingerLiftScale: CGFloat = 1
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        // This will be called whenever a new touch is detected, but we want to know if this
        // is the very first touch of a given gesture so that we can reset the state
        
        self.touches = self.touches.filter { $0.phase != .ended } // remove any touches that ended while we weren't observing (because we were .failed)
        let firstTouches = self.touches.isEmpty
        if firstTouches {
            
            // reset the state of the gesture recognizer (clearing out any previous gestures)
            
            reset()
            
        }
        
        // Keep track of active touches (we'll remove them in touchesEnded)
        for touch in touches {
            self.touches.insert(touch)
        }
        
        
        var lastLocation:CGPoint?
        // if the number of touches changed, store the current location since we'll
        // need to update the pan offset
        if lastNumberOfTouches != self.touches.count {
            lastLocation = currentLocation
        }
        findParameters()
        //update the pan offset if the number of touches changed
        if let lastLocation = lastLocation {

            let points = self.touches.map{ $0.location(in: view) }.sorted(by: pointSort).prefix(2)
            let average = points.reduce(CGPoint.zero, { average, next in
                let x = average.x + next.x / CGFloat(points.count)
                let y = average.y + next.y / CGFloat(points.count)
                return CGPoint(x: x, y: y)
            })
            let location = average
            let difference = location - lastLocation
            panOffset = difference
        }
        
        // if we don't have starting values for the key parameters, lets set them to the currents
        if startingDistance == nil { startingDistance = currentDistance }
        if startingRotation == nil { startingRotation = currentRotation }
        if startingLocation == nil { startingLocation = currentLocation }
        
        // calling super is whats going to ultimately fire the target's selector set in the initializer
        super.touchesBegan(touches, with: event)
        if firstTouches {
            // only set the state to began once (the first touch)
            self.state = .began
   
        }

    
    }
    
    public override func reset() {
        super.reset() 
        startingDistance = nil
        startingLocation = nil
        startingRotation = nil
        
        currentDistance = nil
        currentRotation = nil
        currentLocation = nil
        
        fingerLiftRotation = 0
        fingerLiftScale = 1
        
        panOffset = .zero
        lastNumberOfTouches = 0
        
        state = .possible
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        // remove these touches from our running list
        for touch in touches {
            self.touches.remove(touch)
        }
        
        if self.touches.count == 1,
            let firstTouch = self.touches.first,
            let currentLocation = currentLocation {
            // if, after removing, we only have one... they must have taken a finger off the screen...
            
            // so updat ethe pan offset
            let lastLocation = currentLocation
            let location = firstTouch.location(in: view)
            let difference = location - lastLocation
            panOffset = difference
            
            // and remember the rotation and scale so that we can start there if they put a finger back on screen
            fingerLiftRotation = rotation
            fingerLiftScale = scale
            
            currentRotation = nil
            startingRotation = nil
            
            currentDistance = nil
            startingDistance = nil
            
        }
        
        super.touchesEnded(touches, with: event)
        if self.touches.count == 0, state != .failed {
            // Only call .ended when the last touch is removed
            state = .ended
            
        }
        
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        
        findParameters()
        if startingDistance == nil {
            startingDistance = currentDistance
        }
        if startingRotation == nil { startingRotation = currentRotation }
        if startingLocation == nil { startingLocation = currentLocation }
     
        // we fire the super methods at the end so that the view doesn't update too early (and flicker) with incorrect parameters
        super.touchesMoved(touches, with: event)

        
    }
    
    private func findParameters() {
        
        var points = self.touches.map{ $0.location(in: view) }.sorted(by: pointSort).prefix(2)
        let average = points.reduce(CGPoint.zero, { average, next in
            let x = average.x + next.x / CGFloat(points.count)
            let y = average.y + next.y / CGFloat(points.count)
            return CGPoint(x: x, y: y)
        })
        
        currentLocation = average - panOffset

        if points.count > 1 {
            let firstTouchLocation = points[0]
            let secondTouchLocation = points[1]
            let distance = CGFloat(firstTouchLocation.distanceTo(other: secondTouchLocation))
            
            currentDistance = distance
            
            
            let oldRotation = currentRotation ?? 0

            let newRotation = angleBetween(point1: points[0], point2: points[1])
            let rotationValues = [newRotation,
                                  newRotation + CGFloat.pi,
                                  newRotation - CGFloat.pi,
                                  newRotation + CGFloat.pi * 2]
            let sorted = rotationValues.sorted {
                abs($0 - oldRotation) < abs($1 - oldRotation)
            }
            let closest = sorted[0]
            
            currentRotation = closest
            
        }
        
        lastNumberOfTouches = self.touches.count
        
        
    }
    
    private func pointSort(p1: CGPoint, p2:CGPoint) -> Bool {
    
        if p1.x == p2.x { return p1.y < p2.y }
        return p1.x < p2.x
    
    }
    
    private func angleBetween(point1:CGPoint, point2: CGPoint) -> CGFloat {
        let points = [point1, point2].sorted(by: pointSort)
        return points[0].angle(to: points[1])
    }
    
}

/// Extension to grab the angle between two points
extension CGPoint {
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - self.x
        let originY = comparisonPoint.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        return CGFloat(bearingRadians)
    }
}
