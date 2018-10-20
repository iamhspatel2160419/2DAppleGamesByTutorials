//
//  Firebug.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/23/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class Firebug: Bug {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        name = "Firebug"
        color = .red
        colorBlendFactor = 0.8
        physicsBody?.categoryBitMask = PhysicsCategory.Firebug
    }
    
}
