//
//  GameScene.swift
//  Zombie_Conga
//
//  Created by Neil Hiddink on 9/9/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

var lastUpdateTime:TimeInterval = 0
var dt:TimeInterval = 0

let zombieMovePointsPerSecond: CGFloat = 480.0
var velocity = CGPoint.zero

var zombie = SKSpriteNode()

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
        zombie = SKSpriteNode(imageNamed: "zombie1.png")
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 0
        zombie.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Scale Zombie
        // zombie.xScale = 2.0
        // zombie.yScale = 2.0
        // or
        // zombie.setScale(2.0)
        
        // Add Sprites to Scene
        addChild(background)
        addChild(zombie)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt*1000) milliseconds since last update")
        
        moveSprite(sprite: zombie, velocity: velocity)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        
    }
    
    func moveZombieTowardTouch(touchLocation: CGPoint) {
        // Subtract position vectors of touch and zombie to calculate offset vector
        let offset = CGPoint(x: touchLocation.x - zombie.position.x, y: touchLocation.y - zombie.position.y)
        let offsetLength = sqrt(offset.x * offset.x + offset.y * offset.y)
        // Normalize the vector using the unit vector
        let offsetDirection = CGPoint(x: offset.x / CGFloat(offsetLength), y: offset.y / CGFloat(offsetLength))
        
        velocity = CGPoint(x: offsetDirection.x * zombieMovePointsPerSecond, y: offsetDirection.y * zombieMovePointsPerSecond)
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieTowardTouch(touchLocation: touchLocation)
    }
     func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as! UITouch
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as! UITouch
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
}
