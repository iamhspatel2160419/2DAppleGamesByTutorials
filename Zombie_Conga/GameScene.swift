//
//  GameScene.swift
//  Zombie_Conga
//
//  Created by Neil Hiddink on 9/9/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

let pi = CGFloat.pi

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1.png")
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSecond: CGFloat = 480.0
    var velocity: CGPoint = CGPoint.zero
    var playableRect: CGRect
    var lastTouchLocation: CGPoint?
    let zombieRotationsPerSecond: CGFloat = 4.0 * pi
    
    override init(size: CGSize) {
        
        let maxAspectRatio:CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath.init()
        path.addRect(playableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    override func didMove(to: SKView) {
        
        backgroundColor = SKColor.white
        
        let background = SKSpriteNode(imageNamed: "background1.png")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 0
        // zombie.setScale(2.0)
        addChild(zombie)
        
        // debugDrawPlayableArea()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        // print("\(dt*1000) milliseconds since last update")
        
        if let lastTouch = lastTouchLocation {
            // lastTouchLocation is optional
            let diff = lastTouch - zombie.position
            if (diff.length() <= zombieMovePointsPerSecond * CGFloat(dt)) {
                zombie.position = lastTouch
                velocity = CGPoint.zero
            } else {
                rotateZombie()
                calculateZombiePath(location: lastTouch)
                moveSprite(sprite: zombie, velocity: velocity)
            }
        }
        
        boundsCheckZombie()
    }
    
    func sceneTouched(touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        calculateZombiePath(location: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        sceneTouched(touchLocation: touchLocation!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        sceneTouched(touchLocation: touchLocation!)
    }
    
    func rotateZombie() {
        let shortest = shortestAngleBetween(angle1: zombie.zRotation, angle2: velocity.angle)
        let amountToRotate = min(zombieRotationsPerSecond * CGFloat(dt), abs(shortest))
        zombie.zRotation += shortest.sign() * amountToRotate
    }
    
    func calculateZombiePath(location: CGPoint) {
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSecond
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
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
