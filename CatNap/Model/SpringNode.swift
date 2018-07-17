//
//  SpringNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/17/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class SpringNode: SKSpriteNode {
    
}

extension SpringNode: EventListenerNode {
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}

extension SpringNode: InteractiveNode {
    
    func interact() {
        isUserInteractionEnabled = false
        physicsBody!.applyImpulse(CGVector(dx: 0, dy: 250), at: CGPoint(x: size.width/2, y: size.height))
        run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.removeFromParent()]))
    }
}
