//
//  PlayerShip.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class PlayerShip: Entity {
    
    init(entityPosition: CGPoint) {
        let entityTexture = PlayerShip.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "playerShip"
        
        configureCollisionBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func generateTexture() -> SKTexture? {

        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken = "playerShip"
        }
        
        // See extension in Entity.swift
        DispatchQueue.once(token: SharedTexture.onceToken) {
            let mainShip = SKLabelNode(fontNamed: "Arial")
            mainShip.name = "mainship"
            mainShip.fontSize = 40
            mainShip.fontColor = SKColor.white
            mainShip.text = "▲"

            let wings = SKLabelNode(fontNamed: "Arial")
            wings.name = "wings"
            wings.fontSize = 45
            wings.text = "< >"
            wings.fontColor = SKColor.white
            wings.position = CGPoint(x: 0, y: 10)
            wings.zRotation = CGFloat(180.0).degreesToRadians()
            
            mainShip.addChild(wings)

            let textureView = SKView()
            SharedTexture.texture = textureView.texture(from: mainShip)!
            SharedTexture.texture.filteringMode = .nearest
        }
        
        return SharedTexture.texture
    }
    
    func configureCollisionBody() {
        // Set up the physics body for this entity using a circle around the ship
        physicsBody = SKPhysicsBody(circleOfRadius: 15)
        
        // There is no gravity in the game so it shoud be switched off for this physics body
        physicsBody?.affectedByGravity = false
        
        // Specify the type of physics body this is using the ColliderType defined in the Entity
        // class. This tells the physics engine that this entity is the player
        physicsBody?.categoryBitMask = ColliderType.Player
        
        // We don't want the physics engine applying it's own effects when physics body collide so
        // we switch it off
        physicsBody?.collisionBitMask = 0
        
        // Specify physics bodies we want this entity to be able to collide with. Specifying Enemy
        // means that the physics collision method inside GameScene will be called when this entity
        // collides with an Entity that is marked as ColliderType.Enemy
        physicsBody?.contactTestBitMask = ColliderType.Enemy
    }
    
    override func collidedWith(body: SKPhysicsBody, contact: SKPhysicsContact) {
        // This method is called from GameScene didBeginContact(contact:) when the player entity
        // hits an enemy entity. When that happens the players health is reduced by 5 and a check
        // makes sure that the health cannot drop below zero
        health -= 5
        if health < 0 {
            health = 0
        }
    }
}
