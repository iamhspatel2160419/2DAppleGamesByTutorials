//
//  GameScene.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/25/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let playableRect: CGRect
    let hudLayerNode = SKNode()
    let hudHeight: CGFloat = 90
    
    let scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    var scoreFlashAction: SKAction!
    let healthBarString: NSString = "===================="
    let playerHealthLabel = SKLabelNode(fontNamed: "Arial")
    
    let playerLayerNode = SKNode()
    var playerShip: PlayerShip!
    
    var deltaPoint = CGPoint.zero
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0 //iPhone 5"
        let maxAspectRatioWidth = size.height / maxAspectRatio
        let playableMargin = (size.width-maxAspectRatioWidth) / 2.0
        playableRect = CGRect(x: playableMargin, y: 0,
                              width: size.width - playableMargin / 2,
                              height: size.height - hudHeight)
        super.init(size: size)
        setupSceneLayers()
        setUpUI()
        setupEntities()
    }
    
    override func update(_ currentTime: TimeInterval) {
        var newPoint:CGPoint = playerShip.position + deltaPoint

        playerShip.position = CGPoint(x: newPoint.x.clamp(min: playableRect.minX, max: playableRect.maxX),
                                      y: newPoint.y.clamp(min: playableRect.minY, max: playableRect.maxY))
        deltaPoint = CGPoint.zero
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentTouchLocation = touch?.location(in: self)
        let previousTouchLocation = touch?.previousLocation(in: self)
        deltaPoint = currentTouchLocation! - previousTouchLocation!
    }
    
    func setupSceneLayers() {
        playerLayerNode.zPosition = 50
        hudLayerNode.zPosition = 100
        addChild(playerLayerNode)
        addChild(hudLayerNode)
    }
    
    func setUpUI() {
        
        let backgroundSize = CGSize(width: size.width, height:hudHeight)
        let backgroundColor = SKColor.black
        let hudBarBackground = SKSpriteNode(color: backgroundColor, size: backgroundSize)
        
        scoreLabel.fontSize = 50
        scoreLabel.text = "Score: 0"
        scoreLabel.name = "scoreLabel"
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - hudBarBackground.size.height / 4)
        hudLayerNode.addChild(scoreLabel)
        
        hudBarBackground.position = CGPoint(x:0, y: size.height - hudHeight)
        hudBarBackground.anchorPoint = CGPoint.zero
        hudLayerNode.addChild(hudBarBackground)
        
        scoreFlashAction = SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)])
        scoreLabel.run(SKAction.repeat(scoreFlashAction, count: 20))
        
        let playerHealthBackgroundLabel = SKLabelNode(fontNamed: "Arial")
        playerHealthBackgroundLabel.name = "playerHealthBackground"
        playerHealthBackgroundLabel.fontColor = SKColor.darkGray
        playerHealthBackgroundLabel.fontSize = 50
        playerHealthBackgroundLabel.text = healthBarString as String?

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
    }
    
    func setupEntities() {
        playerShip = PlayerShip(entityPosition: CGPoint(x: size.width / 2, y: 100))
        playerLayerNode.addChild(playerShip)
    }
    
}
