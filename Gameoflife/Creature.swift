//
//  Creature.swift
//  Gameoflife
//
//  Created by Marshall Cain on 6/22/17.
//  Copyright © 2017 Marshall Cain. All rights reserved.
//

import SpriteKit

class Creature: SKSpriteNode {
    
    // The current status of the creature
    var isAlive: Bool = false {
        didSet {
            isHidden = !isAlive
        }
    }
    
    // Number of living neighboring creatures
    var neighborCount = 0
    
    init() {
        
        // Initialize with the 'bubble' asset
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        // Set Z-Position on top of grid
        zPosition = 1
        
        // Set anchor point to bottom-left
        anchorPoint = CGPoint(x: 0, y: 0)
        
        // Makes sure the creature is hidden by default
        isHidden = true
    }
    
    // Required to inherit SKSpriteNode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
