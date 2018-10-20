//
//  BlockNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/12/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: BlockNode: SKSpriteNode, EventListenerNode, InteractiveNode

class BlockNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    
    // MARK: EventListenerNode Methods
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    // MARK: InteractiveNode Protocol Methods
    
    func interact() {
        isUserInteractionEnabled = false
        
        run(SKAction.sequence([SKAction.playSoundFileNamed("pop.mp3", waitForCompletion: false),
                               SKAction.scale(to: 0.8, duration: 0.1),
                               SKAction.removeFromParent()
                              ]))
    }
    
    // MARK: Touch Methods
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // print("destroy block")
        interact()
    }
}
