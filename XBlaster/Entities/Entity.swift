//
//  Entity.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/25/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit
class Entity : SKSpriteNode {

    var direction = CGPoint.zero
    var health = 100.0
    var maxHealth = 100.0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: SKColor.white, size:
            texture.size())
        self.position = position
    }

    class func generateTexture() -> SKTexture? {
        // Overridden by subclasses
        return nil
    }

    func update(delta: TimeInterval) {
    
    }
}
