//
//  BedNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    
    
    // MARK: EventListener Node
    
    func didMoveToScene() {
        print("Bed added to scene")
    }
}
