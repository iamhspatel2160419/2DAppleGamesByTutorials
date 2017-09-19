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
    let zombieAnimation: SKAction
    
    override init(size: CGSize) {
        
        let maxAspectRatio:CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight) / 2.0
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var textures:[SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        zombieAnimation = SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 0.1))
        
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
        
        run(SKAction.repeatForever(zombieAnimation))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnEnemy),
                                                      SKAction.wait(forDuration: 2.0)])))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnCat),
                                                            SKAction.wait(forDuration: 1.0)])))
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
                stopZombieAnimation()
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
        startZombieAnimation()
        let offset = location - zombie.position
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSecond
    }
    
    func startZombieAnimation() {
        if zombie.action(forKey: "animation") == nil {
            zombie.run(SKAction.repeatForever(zombieAnimation), withKey: "animation")
        }
    }
    func stopZombieAnimation() {
        zombie.removeAction(forKey: "animation")
    }
    
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
        sprite.position += amountToMove
        //let aninmateAction = SKAction.animate(with: ["zombie1.png", "zombie2.png", "zombie3.png", "zombie4.png"], timePerFrame: 0.2)
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
    
    func spawnEnemy(){
        let enemy = SKSpriteNode(imageNamed: "enemy.png")
        enemy.position = CGPoint(x: size.width + enemy.size.width/2,
                                 y: CGFloat.random(
                                    min: playableRect.minY + enemy.size.height / 2,
                                    max: playableRect.maxY - enemy.size.height / 2))
        addChild(enemy)
        let moveAction = SKAction.moveTo(x: -enemy.size.width / 2, duration: 2.0)
        let removeAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func spawnCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.position = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                               y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        cat.setScale(0)
        addChild(cat)

        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        let wait = SKAction.wait(forDuration: 10.0)
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, wait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
}
