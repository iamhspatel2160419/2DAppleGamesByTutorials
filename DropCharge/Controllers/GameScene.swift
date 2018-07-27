//
//  GameScene.swift
//  DropCharge
//
//  Created by Neil Hiddink on 7/25/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

enum GameStatus: Int {
    case waitingForTap = 0
    case waitingForBomb = 1
    case playing = 2
    case gameOver = 3
}
enum PlayerStatus: Int {
    case idle = 0
    case jump = 1
    case fall = 2
    case lava = 3
    case dead = 4
}

struct PhysicsCategory {
    static let None: UInt32              = 0
    static let Player: UInt32            = 0b1      // 1
    static let PlatformNormal: UInt32    = 0b10     // 2
    static let PlatformBreakable: UInt32 = 0b100    // 4
    static let CoinNormal: UInt32        = 0b1000   // 8
    static let CoinSpecial: UInt32       = 0b10000  // 16
    static let Edges: UInt32             = 0b100000 // 32
}

// MARK: GameScene: SKScene

class GameScene: SKScene {
 
    // MARK: Properties
    
    var gameState = GameStatus.waitingForTap
    var playerState = PlayerStatus.idle
    
    var bgNode: SKNode!
    var fgNode: SKNode!
    var backgroundOverlayTemplate: SKNode!
    var backgroundOverlayHeight: CGFloat!
    var player: SKSpriteNode!
    
    var platform5Across: SKSpriteNode!
    var coinArrow: SKSpriteNode!
    var lastOverlayPosition = CGPoint.zero
    var lastOverlayHeight: CGFloat = 0.0
    var levelPositionY: CGFloat = 0.0
    
    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        setupNodes()
        setupLevel()
        setupPlayer()
        
        let scale = SKAction.scale(to: 1.0, duration: 0.5)
        fgNode.childNode(withName: "Ready")!.run(scale)
        
        physicsWorld.contactDelegate = self
    }
    
    // MARK: Helper Methods
    
    func setupNodes() {
        let worldNode = childNode(withName: "World")!
        
        bgNode = worldNode.childNode(withName: "Background")!
        backgroundOverlayTemplate = (bgNode.childNode(withName: "Overlay")!.copy() as! SKNode)
        backgroundOverlayHeight = backgroundOverlayTemplate.calculateAccumulatedFrame().height
        
        fgNode = worldNode.childNode(withName: "Foreground")!
        player = (fgNode.childNode(withName: "Player") as! SKSpriteNode)
        fgNode.childNode(withName: "Bomb")?.run(SKAction.hide())
        
        platform5Across = loadForegroundOverlayTemplate("Platform5Across")
        coinArrow = loadForegroundOverlayTemplate("CoinArrow")
    }
    
    func setupLevel() {
        let initialPlatform = platform5Across.copy() as! SKSpriteNode
        var overlayPosition = player.position
        
        overlayPosition.y = player.position.y - (player.size.height * 0.5 + initialPlatform.size.height * 0.20)
        initialPlatform.position = overlayPosition
        fgNode.addChild(initialPlatform)
        
        lastOverlayPosition = overlayPosition
        lastOverlayHeight = initialPlatform.size.height / 2.0
        
        levelPositionY = bgNode.childNode(withName: "Overlay")!.position.y + backgroundOverlayHeight
        while lastOverlayPosition.y < levelPositionY {
            addRandomForegroundOverlay()
        }
    }
    
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width * 0.3)
        player.physicsBody!.isDynamic = false
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.collisionBitMask = 0
    }
    
    func loadForegroundOverlayTemplate(_ fileName: String) -> SKSpriteNode {
        let overlayScene = SKScene(fileNamed: fileName)!
        let overlayTemplate = overlayScene.childNode(withName: "Overlay")
        return overlayTemplate as! SKSpriteNode
    }
    
    func createForegroundOverlay(_ overlayTemplate: SKSpriteNode, flipX: Bool) {
        let foregroundOverlay = overlayTemplate.copy() as! SKSpriteNode
        lastOverlayPosition.y = lastOverlayPosition.y + (lastOverlayHeight + (foregroundOverlay.size.height / 2.0))
        lastOverlayHeight = foregroundOverlay.size.height / 2.0
        foregroundOverlay.position = lastOverlayPosition
        if flipX == true {
            foregroundOverlay.xScale = -1.0
        }
        fgNode.addChild(foregroundOverlay)
    }
    
    func addRandomForegroundOverlay() {
        let overlaySprite: SKSpriteNode!
        let platformPercentage = 60
        if Int.random(min: 1, max: 100) <= platformPercentage {
            overlaySprite = platform5Across
        } else {
            overlaySprite = coinArrow
        }
        createForegroundOverlay(overlaySprite, flipX: false)
    }
    
    func createBackgroundOverlay() {
        let backgroundOverlay = backgroundOverlayTemplate.copy() as!
        SKNode
        backgroundOverlay.position = CGPoint(x: 0.0,
                                             y: levelPositionY)
        bgNode.addChild(backgroundOverlay)
        levelPositionY += backgroundOverlayHeight
    }
    
    func bombDrop() {
        gameState = .waitingForBomb
        
        let scale = SKAction.scale(to: 0, duration: 0.4)
        fgNode.childNode(withName: "Title")!.run(scale)
        fgNode.childNode(withName: "Ready")!.run(SKAction.sequence([SKAction.wait(forDuration: 0.2), scale]))
        
        let scaleUp = SKAction.scale(to: 1.25, duration: 0.25)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.25)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatSeq = SKAction.repeatForever(sequence)
        fgNode.childNode(withName: "Bomb")!.run(SKAction.unhide())
        fgNode.childNode(withName: "Bomb")!.run(repeatSeq)
        run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.run(startGame)]))
    }
    
    func startGame() {
        fgNode.childNode(withName: "Bomb")!.removeFromParent()
        gameState = .playing
        player.physicsBody!.isDynamic = true
        superBoostPlayer()
    }
    
    func setPlayerVelocity(_ amount:CGFloat) {
        let gain: CGFloat = 1.5
        player.physicsBody!.velocity.dy = max(player.physicsBody!.velocity.dy, amount * gain)
    }
    
    func jumpPlayer() {
        setPlayerVelocity(650)
    }
    
    func boostPlayer() {
        setPlayerVelocity(1200)
    }
    
    func superBoostPlayer() {
        setPlayerVelocity(1700)
    }
    
    // MARK: Touch Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState == .waitingForTap {
            bombDrop()
        }
    }
    
}

// MARK: GameScene: SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        switch other.categoryBitMask {
            case PhysicsCategory.CoinNormal:
                if let coin = other.node as? SKSpriteNode {
                    coin.removeFromParent()
                    jumpPlayer()
                }
            case PhysicsCategory.PlatformNormal:
                if let _ = other.node as? SKSpriteNode {
                    if player.physicsBody!.velocity.dy < 0 {
                        jumpPlayer()
                    }
                }
            default:
                break
        }
    }
}
