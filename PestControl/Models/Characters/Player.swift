//
//  Player.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/21/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

enum PlayerSettings {
    static let playerSpeed: CGFloat = 280.0
}

// MARK: Player: SKSpriteNode

class Player: SKSpriteNode {
    
    // MARK: Properties
    
    var animations: [SKAction] = []
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    init() {
        // texture uses custom init declared in Extensions.swift
        let texture = SKTexture(pixelImageNamed: "player_ft1")
        super.init(texture: texture, color: .white, size: texture.size())
        name = "Player"
        zPosition = 50
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.restitution = 1.0
        physicsBody?.linearDamping = 0.5
        physicsBody?.friction = 0
        physicsBody?.allowsRotation = false
        
        createAnimations(character: "player")
    }
    
    // MARK: Helper Methods
    
    func move(target: CGPoint) {
        guard let physicsBody = physicsBody else { return }
        let newVelocity = (target - position).normalized()
            * PlayerSettings.playerSpeed
        physicsBody.velocity = CGVector(point: newVelocity)
        
        //print("* \(animationDirection(for: physicsBody.velocity))")
        checkDirection()
    }
    
    func checkDirection() {
        guard let physicsBody = physicsBody else { return }

        let direction = animationDirection(for: physicsBody.velocity)

        if direction == .left {
            xScale = abs(xScale)
        }
        if direction == .right {
            xScale = -abs(xScale)
        }

        run(animations[direction.rawValue], withKey: "animation")
    }
    
}

// MARK: Player: Animatable

extension Player: Animatable {}
