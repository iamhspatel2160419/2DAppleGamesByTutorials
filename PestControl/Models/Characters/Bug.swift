//
//  Bug.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/21/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

enum BugSettings {
    static let bugDistance: CGFloat = 16.0
}

// MARK: Bug: SKSpriteNode

class Bug: SKSpriteNode {
    
    // MARK: Properties
    
    var animations: [SKAction] = []
    
    // MARK: Initialization
    
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
        
        physicsBody?.categoryBitMask = PhysicsCategory.Bug
        
        createAnimations(character: "bug")
    }
    
    // MARK: Helper Methods
    
    func move() {

        let randomX = CGFloat(Int.random(min: -1, max: 1))
        let randomY = CGFloat(Int.random(min: -1, max: 1))
        let vector = CGVector(dx: randomX * BugSettings.bugDistance, dy: randomY * BugSettings.bugDistance)
        
        let moveBy = SKAction.move(by: vector, duration: 1)
        let moveAgain = SKAction.run(move)
        
        let direction = animationDirection(for: vector)

        if direction == .left {
            xScale = abs(xScale)
        } else if direction == .right {
            xScale = -abs(xScale)
        }

        run(animations[direction.rawValue], withKey: "animation")
        run(SKAction.sequence([moveBy, moveAgain]))
    }
    
    func die() {
        removeAllActions()
        texture = SKTexture(pixelImageNamed: "bug_lt1")
        yScale = -1
        physicsBody = nil
        
        run(SKAction.sequence([SKAction.fadeOut(withDuration: 3),
                               SKAction.removeFromParent()]))
    }
    
}

// MARK: Bug: Animatable

extension Bug: Animatable {}
