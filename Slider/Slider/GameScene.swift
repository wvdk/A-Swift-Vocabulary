//
//  GameScene.swift
//  Slider
//
//  Created by Wesley Van der Klomp on 8/8/17.
//  Copyright © 2017 Wesley Van der Klomp. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var label = SKLabelNode(text: "Test")
    var slider = Slider()
    
    /// Calculated center point of the scene.
    private var center: CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 2)
    }

    override func didMove(to view: SKView) {
        label.fontColor = .red
        
        label.position = CGPoint(x: center.x, y: center.y + 100)
        slider.position = CGPoint(x: center.x - slider.size.width / 2, y: center.y - slider.size.height / 2)
        
        slider.addValueChangeHandler(handler: { newValue in
            print("Updating label with value: \(newValue)")
            
            self.label.text = newValue.description
        })
        
        addChild(label)
        addChild(slider.node)
    }
    
}
