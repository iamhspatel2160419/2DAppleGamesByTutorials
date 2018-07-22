//
//  GameScene.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/15/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: GameScene: SKScene

class GameScene: SKScene {
    
    // MARK: Properties
    
    var background: SKTileMapNode!
    var player = Player()
    
    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        addChild(player)
    }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        background = childNode(withName: "background") as? SKTileMapNode
    }
    
}
