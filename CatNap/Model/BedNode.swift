//
//  BedNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: BedNode: SKSpriteNode

class BedNode: SKSpriteNode {
    
}

// MARK: BedNode: EventListenerNode

extension BedNode: EventListenerNode {
    
    func didMoveToScene() {
        // print("Bed added to scene")
        
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
    }
    
}
