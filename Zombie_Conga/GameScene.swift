//
//  GameScene.swift
//  Zombie_Conga
//
//  Created by Neil Hiddink on 9/9/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to: SKView) {
        
        // Initial Setup
        backgroundColor = SKColor.white
        
        // Create Background Sprite
        let background = SKSpriteNode(imageNamed: "background1.png")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        //background.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Create Zombie Sprite
        let zombie = SKSpriteNode(imageNamed: "zombie1.png")
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 0
        zombie.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Add Sprites to Scene
        addChild(background)
        addChild(zombie)
    }
}
