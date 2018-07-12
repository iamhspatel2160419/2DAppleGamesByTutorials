//
//  GameScene.swift
//  Cat Nap
//
//  Created by Neil Hiddink on 10/2/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None:  UInt32 = 0
    static let Cat:   UInt32 = 0b1 // 1
    static let Block: UInt32 = 0b10 // 2
    static let Bed:   UInt32 = 0b100 // 4
}

protocol EventListenerNode {
    func didMoveToScene()
}

// MARK: GameScene: SKScene

class GameScene: SKScene {
    
    // MARK: Properties
    
    var bedNode: BedNode!
    var catNode: CatNode!
    
    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height
            - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
                                  width: size.width, height: size.height-playableMargin*2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        bedNode = (childNode(withName: "bed") as! BedNode)
        catNode = (childNode(withName: "//cat_body") as! CatNode)
        catNode.isPaused = false
        
        // SKTAudio.sharedInstance().playBackgroundMusic("backgroundMusic.mp3")
    }
}
