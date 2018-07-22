//
//  Player.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/21/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init()")
    }
    
    init() {
        let texture = SKTexture(imageNamed: "player_ft1")
        super.init(texture: texture, color: .white,
                   size: texture.size())
        name = "Player"
        zPosition = 50
    }
}
