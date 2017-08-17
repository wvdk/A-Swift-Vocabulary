//
//  InterfaceElementInteractionResponder.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/17/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

/// Sends interactions (click, drag, etc) to it's owning InterfaceElement.
///
/// This protocol is likely conformed to by some subclass of NSResponder. It will then take those `mouseDown()`, `mouseClicked()`, etc. events and call the appropriate methods on `owner`.
protocol InterfaceElementInteractionResponder {
    
//    var owner: 
    
}
