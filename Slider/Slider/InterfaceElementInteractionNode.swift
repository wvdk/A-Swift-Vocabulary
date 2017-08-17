//
//  InterfaceElementInteractionDelegate.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/16/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

/// Sends interaction events to the owner so it can handle when a user clicks, drags, etc. on the node.
protocol InterfaceElementInteractionDelegate {
    
    /// A reverence to the `InterfaceElement` that owns this node.
    var owner: InterfaceElement? { get set }
    
}
