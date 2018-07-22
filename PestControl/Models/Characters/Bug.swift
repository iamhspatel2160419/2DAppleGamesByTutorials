//
//  Bug.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/21/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class Bug: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    init() {
        // texture uses custom init declared in Extensions.swift
        let texture = SKTexture(pixelImageNamed: "bug_ft1")
        super.init(texture: texture, color: .white, size: texture.size())
        name = "Bug"
        zPosition = 50
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody?.restitution = 0.5
        physicsBody?.allowsRotation = false
    }
}
