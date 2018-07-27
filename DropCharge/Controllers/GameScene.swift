//
//  GameScene.swift
//  DropCharge
//
//  Created by Neil Hiddink on 7/25/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: GameScene: SKScene

class GameScene: SKScene {
 
    // MARK: Properties
    
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
    
    func createBackgroundOverlay() {
        let backgroundOverlay = backgroundOverlayTemplate.copy() as!
        SKNode
        backgroundOverlay.position = CGPoint(x: 0.0,
                                             y: levelPositionY)
        bgNode.addChild(backgroundOverlay)
        levelPositionY += backgroundOverlayHeight
    }
}
