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
    let catCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed("hitCatLady.wav", waitForCompletion: false)
    
    var isZombieInvincible: Bool = false
    
    let catMovePointsPerSecond: CGFloat = 480.0
    
    var lives = 5
    var gameOver = false
    
    let backgroundMovePointsPerSecond: CGFloat = 200.0
    
    let backgroundLayer = SKNode()
    
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
        
        playBackgroundMusic(filename: "backgroundMusic.mp3")
        
        backgroundLayer.zPosition = -1
        addChild(backgroundLayer)
        backgroundColor = SKColor.white
        
        for i in 0...1 {
            let background = backgroundNode()
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * background.size.width, y: 0)
            background.name = "background"
            backgroundLayer.addChild(background)
        }
        
        zombie.position = CGPoint(x: 400, y: 400)
        zombie.zPosition = 100
        // zombie.setScale(2.0)
        backgroundLayer.addChild(zombie)
        
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
        // checkCollisions()
        moveTrain()
        moveBackground()
        
        if lives <= 0 && !gameOver {
            gameOver = true
            // print("You lose!")
            backgroundMusicPlayer.stop()
            
            let gameOverScene = GameOverScene(size: size, won: false)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    override func didEvaluateActions() {
        checkCollisions()
    }
    
    func backgroundNode() -> SKSpriteNode {
        
        let backgroundNode = SKSpriteNode()
        backgroundNode.anchorPoint = CGPoint.zero
        backgroundNode.name = "background"

        let background1 = SKSpriteNode(imageNamed: "background1")
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        backgroundNode.addChild(background1)

        let background2 = SKSpriteNode(imageNamed: "background2")
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)
        backgroundNode.addChild(background2)

        backgroundNode.size = CGSize(width: background1.size.width + background2.size.width,
                                     height: background1.size.height)
        return backgroundNode
    }
    
    func moveBackground() {
        
        let backgroundVelocity = CGPoint(x: -self.backgroundMovePointsPerSecond, y: 0)
        let amountToMove = backgroundVelocity * CGFloat(self.dt)
        backgroundLayer.position += amountToMove

        backgroundLayer.enumerateChildNodes(withName: "background") { node, _ in
            let background = node as! SKSpriteNode
            let backgroundScreenPos = self.backgroundLayer.convert(background.position, to: self)
            if backgroundScreenPos.x <= -background.size.width {
                background.position = CGPoint(x: background.position.x + background.size.width*2,
                                              y: background.position.y)
            }
        }
    }
    
    // MARK: Scene Touch Handling
    
    func sceneTouched(touchLocation: CGPoint) {
        lastTouchLocation = touchLocation
        calculateZombiePath(location: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: backgroundLayer)
        sceneTouched(touchLocation: touchLocation!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: backgroundLayer)
        sceneTouched(touchLocation: touchLocation!)
    }
    
    // MARK: Zombie Movements
    
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
    }
    
    func boundsCheckZombie() {
        let bottomLeft = backgroundLayer.convert(CGPoint(x: 0, y: playableRect.minY), from: self)
        let topRight = backgroundLayer.convert(CGPoint(x: size.width, y: playableRect.maxY), from: self)
        
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
        enemy.name = "enemy"
        enemy.position = CGPoint(x: size.width + enemy.size.width/2,
                                 y: CGFloat.random(
                                    min: playableRect.minY + enemy.size.height / 2,
                                    max: playableRect.maxY - enemy.size.height / 2))
        backgroundLayer.addChild(enemy)
        let moveAction = SKAction.moveTo(x: -enemy.size.width / 2, duration: 2.5)
        let removeAction = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    func spawnCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        let catScenePosition = CGPoint(x: CGFloat.random(min: playableRect.minX, max: playableRect.maxX),
                                       y: CGFloat.random(min: playableRect.minY, max: playableRect.maxY))
        cat.position = backgroundLayer.convert(catScenePosition, from: self)
        
        cat.setScale(0)
        backgroundLayer.addChild(cat)

        let appear = SKAction.scale(to: 1.0, duration: 0.5)
        cat.zRotation = -pi / 16.0
        
        let leftWiggle = SKAction.rotate(byAngle: pi / 8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversed()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        
        let scaleUp = SKAction.scale(by: 1.2, duration: 0.25)
        let scaleDown = scaleUp.reversed()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])
        let groupWait = SKAction.repeat(group, count: 10)
        
        let disappear = SKAction.scale(to: 0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, groupWait, disappear, removeFromParent]
        cat.run(SKAction.sequence(actions))
    }
    
    // MARK: Collision Detection
    
    func zombieCatCollision(cat: SKSpriteNode) {
        run(catCollisionSound)
        
        cat.name = "train"
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0

        let turnGold = SKAction.colorize(with: UIColor.init(red: 252.0/255.0, green: 194.0/255.0, blue: 0.0, alpha: 1.0), colorBlendFactor: 0.8, duration: 0.2)
        cat.run(turnGold)
    }
    func zombieEnemyCollision(enemy: SKSpriteNode) {
        
        run(enemyCollisionSound)
        loseCats()
        lives -= 1
        isZombieInvincible = true
        
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customAction(withDuration: duration) {
            node, elapsedTime in
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            node.isHidden = remainder > slice / 2
        }
        let turnRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.3, duration: 0.2)
        let originalColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.0, duration: 0.2)
        let groupAction = SKAction.group([blinkAction, turnRed])
        
        let setHidden = SKAction.run() {
            self.zombie.isHidden = false
            self.isZombieInvincible = false
        }
        zombie.run(SKAction.sequence([groupAction, setHidden, originalColor]))
    }
    func checkCollisions() {
        var hitCats: [SKSpriteNode] = []
        backgroundLayer.enumerateChildNodes(withName: "cat") { node, _ in
            let cat = node as! SKSpriteNode
            if cat.frame.intersects(self.zombie.frame) {
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieCatCollision(cat: cat)
        }
        
        if isZombieInvincible {
            return
        }
        
        var hitEnemies: [SKSpriteNode] = []
        backgroundLayer.enumerateChildNodes(withName: "enemy") { node, _ in
            let enemy = node as! SKSpriteNode
            
            if node.frame.insetBy(dx: 20, dy: 20).intersects(self.zombie.frame) {
                hitEnemies.append(enemy)
            }
        }
    
        for enemy in hitEnemies {
            zombieEnemyCollision(enemy: enemy)
        }
    }
    
    func moveTrain() {
        var trainCount = 0
        
        var targetPosition = zombie.position
        backgroundLayer.enumerateChildNodes(withName: "train") {
            node, _ in
            
            trainCount += 1
            
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMovePerSecond = direction * self.catMovePointsPerSecond
                let amountToMove = amountToMovePerSecond * CGFloat(actionDuration)
                let moveAction = SKAction.moveBy(x: amountToMove.x, y: amountToMove.y, duration: actionDuration)
                
                node.run(moveAction)
            }
            targetPosition = node.position
        }
        
        if trainCount >= 20 && !gameOver {
            gameOver = true
            //print("You win!")
            backgroundMusicPlayer.stop()
            
            let gameOverScene = GameOverScene(size: size, won: true)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
    }
    
    func loseCats() {

        var loseCount = 0
        backgroundLayer.enumerateChildNodes(withName: "train") { node, stop in

            var randomSpot = node.position
            randomSpot.x += CGFloat.random(min: -100, max: 100)
            randomSpot.y += CGFloat.random(min: -100, max: 100)

            node.name = ""
            node.run(
                SKAction.sequence([
                    SKAction.group([
                        SKAction.rotate(byAngle: pi * 4, duration: 1.0),
                        SKAction.move(to: randomSpot, duration: 1.0),
                        SKAction.scale(to: 0, duration: 1.0)
                    ]),
                    SKAction.removeFromParent()
                ]))
            loseCount += 1
            if loseCount >= 2 {
                stop.pointee = true
            }
        }
    }
}
