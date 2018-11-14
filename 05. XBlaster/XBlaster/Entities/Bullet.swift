//
//  Bullet.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/29/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit


class Bullet: Entity {
    
    init(entityPosition: CGPoint) {
        let entityTexture = Bullet.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "bullet"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func generateTexture() -> SKTexture? {
        
        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken = "bullet"
        }
        
        // See extension in Entity.swift
        DispatchQueue.once(token: SharedTexture.onceToken) {
            let bullet = SKLabelNode(fontNamed: "Arial")
            bullet.name = "bullet"
            bullet.fontSize = 40
            bullet.fontColor = SKColor.white
            bullet.text = "•"
        
            let textureView = SKView()
            SharedTexture.texture = textureView.texture(from: bullet)!
            SharedTexture.texture.filteringMode = .nearest
        }
        
        return SharedTexture.texture
    }
    
    func configureCollisionBody() {
        // Set the PlayerShip class for details of how the physics body configuration is used.
        // More details are provided in Chapter 9 "Beginner Physics" in the book also
        physicsBody = SKPhysicsBody(circleOfRadius:5)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = ColliderType.Bullet
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = ColliderType.Enemy
    }
    
    override func collidedWith(body: SKPhysicsBody, contact: SKPhysicsContact) {
        removeFromParent()
    }
}
