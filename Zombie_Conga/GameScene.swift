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

let zombie = SKSpriteNode(imageNamed: "zombie1.png")

let touchGR = UITapGestureRecognizer()

var playableRect: CGRect = CGRect()

class GameScene: SKScene {
    
    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height-playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        super.init(size: size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        zombie.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Scale Zombie
        // zombie.xScale = 2.0
        // zombie.yScale = 2.0
        // or
        // zombie.setScale(2.0)
        
        touchGR.addTarget(self, action: #selector(GameScene.moveSpriteToTouch))
        touchGR.numberOfTapsRequired = 1
        touchGR.numberOfTouchesRequired = 1
        self.view!.addGestureRecognizer(touchGR)
        
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
        
        moveSprite(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
        rotateSprite(sprite: zombie, direction: velocity)
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        print("Amount to move: \(amountToMove)")
        sprite.position += amountToMove
    }
    
    @objc func moveSpriteToTouch() {
        let touchLocation = touchGR.location(in: self.view)
        
        let offset = CGPoint(x: touchLocation.x - zombie.position.x, y: touchLocation.y - zombie.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSecond,
                           y: direction.y * zombieMovePointsPerSecond)
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = CGFloat(
            atan2(Double(direction.y), Double(direction.x)))
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0,
                                 y: playableRect.minY)
        let topRight = CGPoint(x: size.width,
                               y: playableRect.maxY)
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
}
