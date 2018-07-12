//
//  CatNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: CatNode: SKSpriteNode

class CatNode: SKSpriteNode {
    
}

// MARK: CatNode: EventListenerNode

extension CatNode: EventListenerNode {
    
    func didMoveToScene() {
        print("Cat added to scene")
    }
    
}
