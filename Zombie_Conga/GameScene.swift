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

let zombieMovePointsPerSecond: CGFloat = 240.0
var velocity = CGPoint.zero

let zombie = SKSpriteNode(imageNamed: "zombie1.png")

let touchGR = UITapGestureRecognizer()
let pinchInGR = UIPinchGestureRecognizer()
let pinchOutGR = UIPinchGestureRecognizer()
let rotateGR = UIRotationGestureRecognizer()

class GameScene: SKScene {
    override func didMove(to: SKView) {
        
        // Initial Setup
        backgroundColor = SKColor.white
        
        // Create Background Sprite
        let background = SKSpriteNode(imageNamed: "background1.png")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        //background.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Position Zombie Sprite
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 0
        zombie.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Scale Zombie
        // zombie.xScale = 2.0
        // zombie.yScale = 2.0
        // or
        // zombie.setScale(2.0)
        
        //touchGR.addTarget(self, action: #selector(GameScene.touchedDown))
        //pinchInGR.addTarget(self, action: #selector(GameScene.pinchedIn))
        //pinchOutGR.addTarget(self, action: #selector(GameScene.pinchedOut))
        rotateGR.addTarget(self, action: #selector(GameScene.rotatedView (_:) ))
        self.view!.addGestureRecognizer(rotateGR)
        
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
        //print("\(dt*1000) milliseconds since last update")
        
        moveSprite(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSecond, y: zombie.zRotation))
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
        
    }
    
    @objc func touchedDown() {}
    
    @objc func pinchedIn() {}
    
    @objc func pinchedOut() {}
    
    @objc func rotatedView(_ sender: UIRotationGestureRecognizer) {
        
        zombie.zRotation = sender.rotation
        
    }
    
}
