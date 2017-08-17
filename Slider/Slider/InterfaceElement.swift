//
//  InterfaceElement.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/16/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import Foundation

/**********************************
 Developer Note:
 
 I'm currently not using InterfaceElement, InterfaceElementInteractionDelegate, or InterfaceElementInteractionResponder anywhere in this project. I began exploring ways to solidify how I could approach building out my own personal UI framework using SpriteKit as the backend. While I still think this might happen long term, I've dropped these little protocols because I haven't reached the point where I feel like I know what I'm doing. So I'll keep tackling things in an adhock way for now.
 
 **********************************/

protocol InterfaceElement {
    
    /// A `InterfaceElementNode` for adding to a SpriteKit scene.
    ///
    /// Things like position, size, or color should all be updated automatically when you change the properties of a `InterfaceElement` object. So you should rarely need to set properties of this 'node` property directly.
//    var node: InterfaceElementNode? { get set }
    
}
