//
//  MessageNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/13/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: MessageNode: SKLabelNode

class MessageNode: SKLabelNode {
    
    // MARK: Properties
    
    private var numberOfBounces = 0
    
    // MARK: Initialization
    
    convenience init(message: String) {
        self.init(fontNamed: "AvenirNext-Regular")
        
        text = message
        fontSize = 256.0
        fontColor = SKColor.gray
        zPosition = 100
        
        let front = SKLabelNode(fontNamed: "AvenirNext-Regular")
        front.text = message
        front.fontSize = 256.0
        front.fontColor = SKColor.white
        front.position = CGPoint(x: -2, y: -2)
        addChild(front)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 10)
        physicsBody!.collisionBitMask = PhysicsCategory.Edge
        physicsBody!.categoryBitMask = PhysicsCategory.Label
        physicsBody!.contactTestBitMask = PhysicsCategory.Edge
        physicsBody!.restitution = 0.7
    }
    
    func didBounce(){
        numberOfBounces += 1
        if numberOfBounces >= 4 {
            self.removeFromParent()
        }
    }
    
}
