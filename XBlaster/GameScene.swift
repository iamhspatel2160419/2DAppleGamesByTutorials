//
//  GameScene.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/25/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Edit Undo Line BRK")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 80
        myLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(myLabel)
    }
}
