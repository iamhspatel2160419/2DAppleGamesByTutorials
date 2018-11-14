//
//  SKSpriteNode+CircuitRacer.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

extension SKSpriteNode {
    func resetPhysicsForcesAndVelocity() {
        zRotation = 0
        if let pBody = physicsBody {
            pBody.angularVelocity = 0
            pBody.velocity = .zero
        }
    }
}
