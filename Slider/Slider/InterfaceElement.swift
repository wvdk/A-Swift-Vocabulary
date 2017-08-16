//
//  InterfaceElement.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/16/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

protocol InterfaceElement {
    
    /// A `InterfaceElementNode` for adding to a SpriteKit scene.
    ///
    /// Things like position, size, or color should all be updated automatically when you change the properties of a `InterfaceElement` object. So you should rarely need to set properties of this 'node` property directly.
    var node: InterfaceElementNode? { get set }
    
}
