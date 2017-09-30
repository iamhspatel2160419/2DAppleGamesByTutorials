//
//  GameScene.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/25/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

// Used by update for each loop.
enum GameState {
    case GameRunning
    case GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Nodes
    let playerLayerNode = SKNode()
    let hudLayerNode = SKNode()
    let bulletLayerNode = SKNode()
    var enemyLayerNode = SKNode()
    
    // HUD
    let playableRect: CGRect
    let hudHeight: CGFloat = 90
    let scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    var scoreFlashAction: SKAction!
    let healthBarString: NSString = "===================="
    
    // Player
    let playerHealthLabel = SKLabelNode(fontNamed: "Arial")
    var playerShip: PlayerShip!
    var deltaPoint = CGPoint.zero
    var previousTouchLocation = CGPoint.zero
    
    // Bullet
    var bulletInterval: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    // Game State
    var score = 0
    var gameState = GameState.GameOver
    let gameOverLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    let tapScreenPulseAction = SKAction.repeatForever(SKAction.sequence([
        SKAction.fadeOut(withDuration: 1),
        SKAction.fadeIn(withDuration: 1)
        ]))
    let tapScreenLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    
    override init(size: CGSize) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 //iPhone 5"
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width-maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
                              width: size.width - playableMargin / 2,
                              height: size.height - hudHeight)
        
        super.init(size: size)
        
        gameState = .GameRunning
        
        setupSceneLayers()
        setUpUI()
        setupEntities()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .GameOver {
            restartGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentTouchLocation = touch?.location(in: self)
        let previousTouchLocation = touch?.previousLocation(in: self)
        deltaPoint = currentTouchLocation! - previousTouchLocation!
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        deltaPoint = CGPoint.zero
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        deltaPoint = CGPoint.zero
    }
    
    override func update(_ currentTime: TimeInterval) {
        var newPoint:CGPoint = playerShip.position + deltaPoint

        playerShip.position = CGPoint(x: newPoint.x.clamp(min: playableRect.minX, max: playableRect.maxX),
                                      y: newPoint.y.clamp(min: playableRect.minY, max: playableRect.maxY))
        deltaPoint = CGPoint.zero
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        switch gameState {
        case (.GameRunning):
            bulletInterval += dt
            if bulletInterval > 0.15 {
                bulletInterval = 0

                let bullet = Bullet(entityPosition: playerShip.position)
                bulletLayerNode.addChild(bullet)
                bullet.run(SKAction.sequence([SKAction.moveBy(x: 0, y: size.height, duration: 1),
                                              SKAction.removeFromParent()]))
            }
            
            // Loop through all enemy nodes and run their update method.
            // This causes them to update their position based on their currentWaypoint and position
            for node in enemyLayerNode.children {
                let enemy = node as! Enemy
                enemy.update(delta: self.dt)
            }
            
            // Update the players health label to be the right length based on the players health and also
            // update the color so that the closer to 0 it gets the more red it becomes
            playerHealthLabel.fontColor = SKColor(red: CGFloat(2.0 * (1 - playerShip.health / 100)),
                                                  green: CGFloat(2.0 * playerShip.health / 100),
                                                  blue: 0,
                                                  alpha: 1)
            
            // Calculate the length of the players health bar.
            let healthBarLength = Double(healthBarString.length) * playerShip.health / 100.0
            playerHealthLabel.text = healthBarString.substring(to: Int(healthBarLength))
            
            // If the player health reaches 0 then change the game state.
            if playerShip.health <= 0 {
                gameState = .GameOver
            }
            
        case (.GameOver):
            
            // When the game is over remove all the entities from the scene and add the game over labels
            if !(gameOverLabel.parent != nil) {
                bulletLayerNode.removeAllChildren()
                enemyLayerNode.removeAllChildren()
                playerShip.removeFromParent()
                hudLayerNode.addChild(gameOverLabel)
                hudLayerNode.addChild(tapScreenLabel)
                tapScreenLabel.run(tapScreenPulseAction)
            }
            
            // Set a random color for the game over label
            gameOverLabel.fontColor = SKColor(red: CGFloat(drand48()),
                                              green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
            
        default:
            print("UNKNOWN GAME STATE")
        }
    }
    
    // This method is called by the physics engine when two physics body collide
    func didBeginContact(contact: SKPhysicsContact!) {
        
        // Check to see if Body A is an enamy ship and if so call collided with
        if let enemyNode = contact.bodyA.node {
            if enemyNode.name == "enemy" {
                let enemy = enemyNode as! Entity
                enemy.collidedWith(contact.bodyA, contact: contact)
            }
        }
        
        // ...and now check to see if Body B is the player ship/bullet
        if let playerNode = contact.bodyB.node {
            if playerNode.name == "playerShip" || playerNode.name == "bullet" {
                let player = playerNode as! Entity
                player.collidedWith(contact.bodyA, contact: contact)
            }
        }
    }
    
    func increaseScoreBy(increment: Int) {
        score += increment
        scoreLabel.text = "Score: \(score)"
        scoreLabel.removeAllActions()
        scoreLabel.run(scoreFlashAction)
    }
    
    func restartGame() {
        // Reset the state of the game
        gameState = .GameRunning
        
        // Setup the entities and reset the score
        setupEntities()
        score = 0
        scoreLabel.text = "Score: 0"
        
        // Reset the players health and position
        playerShip.health = playerShip.maxHealth
        playerShip.position = CGPoint(x: size.width / 2, y: 100)
        
        // Remove the game over HUD labels
        gameOverLabel.removeFromParent()
        tapScreenLabel.removeAllActions()
        tapScreenLabel.removeFromParent()
    }

}

// MARK: UI Setup

extension GameScene {
    func setupSceneLayers() {
        playerLayerNode.zPosition = 50
        hudLayerNode.zPosition = 100
        bulletLayerNode.zPosition = 25
        enemyLayerNode.zPosition = 35
        
        addChild(playerLayerNode)
        addChild(hudLayerNode)
        addChild(bulletLayerNode)
        addChild(enemyLayerNode)
    }
    
    func setUpUI() {
        
        let backgroundSize = CGSize(width: size.width, height:hudHeight)
        let backgroundColor = SKColor.black
        let hudBarBackground = SKSpriteNode(color: backgroundColor, size: backgroundSize)
        hudBarBackground.position = CGPoint(x:0, y: size.height - hudHeight)
        hudBarBackground.anchorPoint = CGPoint.zero
        hudLayerNode.addChild(hudBarBackground)
        
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.name = "scoreLabel"
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - hudBarBackground.size.height / 4)
        hudLayerNode.addChild(scoreLabel)
        
        scoreFlashAction = SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)])
        scoreLabel.run(SKAction.repeat(scoreFlashAction, count: 20))
        
        let playerHealthBackgroundLabel = SKLabelNode(fontNamed: "Arial")
        playerHealthBackgroundLabel.name = "playerHealthBackground"
        playerHealthBackgroundLabel.fontColor = SKColor.darkGray
        playerHealthBackgroundLabel.fontSize = 50
        playerHealthBackgroundLabel.text = healthBarString as String?
        playerHealthBackgroundLabel.zPosition = 0
        
        playerHealthBackgroundLabel.horizontalAlignmentMode = .left
        playerHealthBackgroundLabel.verticalAlignmentMode = .top
        playerHealthBackgroundLabel.position = CGPoint(x: playableRect.minX,
                                                       y: size.height - CGFloat(hudHeight) + playerHealthBackgroundLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthBackgroundLabel)
        
        playerHealthLabel.name = "playerHealthLabel"
        playerHealthLabel.fontColor = SKColor.green
        playerHealthLabel.fontSize = 50
        playerHealthLabel.text = healthBarString.substring(to: 20*75/100)
        playerHealthLabel.horizontalAlignmentMode = .left
        playerHealthLabel.verticalAlignmentMode = .top
        playerHealthLabel.position = CGPoint(x: playableRect.minX,
                                             y: size.height - CGFloat(hudHeight) + playerHealthLabel.frame.size.height)
        hudLayerNode.addChild(playerHealthLabel)
        
        gameOverLabel.name = "gameOverLabel"
        gameOverLabel.fontSize = 100
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.verticalAlignmentMode = .center
        gameOverLabel.position =    CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.text = "GAME OVER";
        
        tapScreenLabel.name = "tapScreen"
        tapScreenLabel.fontSize = 22;
        tapScreenLabel.fontColor = SKColor.white
        tapScreenLabel.horizontalAlignmentMode = .center
        tapScreenLabel.verticalAlignmentMode = .center
        tapScreenLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        tapScreenLabel.text = "Tap Screen To Restart"
    }
    
    func setupEntities() {
        playerShip = PlayerShip(entityPosition: CGPoint(x: size.width / 2, y: 100))
        playerLayerNode.addChild(playerShip)
        
        // Add some EnemyA entities to the scene
        for _ in 0..<3 {
            let enemy = EnemyA(entityPosition: CGPoint(x: CGFloat.random(min: playableRect.origin.x, max: playableRect.size.width),
                                                       y: playableRect.size.height),
                               playableRect: playableRect)
            
            // Set the initialWaypoint for the enemy to a random position within the playableRect
            let initialWaypoint = CGPoint(x: CGFloat.random(min: playableRect.origin.x, max: playableRect.size.width),
                                          y: CGFloat.random(min: 0, max: playableRect.size.height))
            enemy.aiSteering.updateWaypoint(waypoint: initialWaypoint)
            enemyLayerNode.addChild(enemy)
        }
        
        for _ in 0..<3 {
            let enemy = EnemyB(entityPosition: CGPoint(x: CGFloat.random(min: playableRect.origin.x, max: playableRect.size.width),
                                                       y: playableRect.size.height), playableRect: playableRect)
            let initialWaypoint = CGPoint(x: CGFloat.random(min: playableRect.origin.x, max: playableRect.width),
                                          y: CGFloat.random(min: playableRect.height / 2, max: playableRect.height))
            enemy.aiSteering.updateWaypoint(waypoint: initialWaypoint)
            enemyLayerNode.addChild(enemy)
        }
    }
}
