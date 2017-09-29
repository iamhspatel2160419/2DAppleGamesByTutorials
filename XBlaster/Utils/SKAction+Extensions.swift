//
//  SKAction+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

extension SKAction {

    // Performs an action after the specified delay.
    class func afterDelay(delay: TimeInterval, performAction action: SKAction) -> SKAction! {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    
    // Removes the node from its parent after the specified delay.
    class func removeFromParentAfterDelay(delay: TimeInterval) -> SKAction! {
        return SKAction.afterDelay(delay: delay, performAction: SKAction.removeFromParent())
    }
    
    // Creates an action to perform a parabolic jump.
    class func jumpToHeight(height: CGFloat, duration: TimeInterval, originalPosition: CGPoint) -> SKAction! {
        return SKAction.customAction(withDuration: duration) {(node, elapsedTime) in
            let fraction = elapsedTime / CGFloat(duration)
            let yOffset = height * 4 * fraction * (1 - fraction)
            node.position = CGPoint(x: originalPosition.x, y: originalPosition.y + yOffset)
        }
    }
}
