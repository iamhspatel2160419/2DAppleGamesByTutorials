//
//  GameScene.swift
//  Cat Nap
//
//  Created by Neil Hiddink on 10/2/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

protocol EventListenerNode {
    func didMoveToScene()
}

// MARK: GameScene: SKScene

class GameScene: SKScene {
    
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
    }
}
