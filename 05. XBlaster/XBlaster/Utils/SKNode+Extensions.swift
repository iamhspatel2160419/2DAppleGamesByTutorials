//
//  SKNode+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

extension SKNode {
    
    // Lets you treat the node's scale as a CGPoint value.
    var scaleAsPoint: CGPoint {
        get {
            return CGPoint(x: xScale, y: yScale)
        }
        set {
            xScale = newValue.x
            yScale = newValue.y
        }
    }
    
    // Performs an action after the specified delay.
    func afterDelay(delay: TimeInterval, performAction action: SKAction) -> SKAction! {
        return SKAction.sequence([SKAction.wait(forDuration: delay), action])
    }
    
    // Makes this node the frontmost node in its parent.
    func bringToFront() {
        let parent = self.parent
        removeFromParent()
        parent?.addChild(self)
    }
    
    /* Orients the node in the direction that it is moving by tweening its
     * rotation angle. This assumes that at 0 degrees the node is facing up.
     *
     * @param velocity The current speed and direction of the node. You can get
     *        this from node.physicsBody.velocity.
     * @param rate How fast the node rotates. Must have a value between 0.0 and
     *        1.0, where smaller means slower; 1.0 is instantaneous.
     */
    func rotateToVelocity(velocity: CGVector, rate: CGFloat) {
        // Determine what the rotation angle of the node ought to be based on the
        // current velocity of its physics body. This assumes that at 0 degrees the
        // node is pointed up, not to the right, so to compensate we subtract π/4
        // (90 degrees) from the calculated angle.
        let newAngle = atan2(velocity.dy, velocity.dx) - CGFloat.pi / 2
        
        // This always makes the node rotate over the shortest possible distance.
        // Because the range of atan2() is -180 to 180 degrees, a rotation from,
        // -170 to -190 would otherwise be from -170 to 170, which makes the node
        // rotate the wrong way (and the long way) around. We adjust the angle to
        // go from 190 to 170 instead, which is equivalent to -170 to -190.
        if newAngle - zRotation > CGFloat.pi {
            zRotation += CGFloat.pi * 2.0
        } else if zRotation - newAngle > CGFloat.pi {
            zRotation -= CGFloat.pi * 2.0
        }
        
        // Use the "standard exponential slide" to slowly tween zRotation to the
        // new angle. The greater the value of rate, the faster this goes.
        zRotation += (newAngle - zRotation) * rate
    }
}

