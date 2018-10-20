//
//  PictureNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/21/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: PictureNode: SKSpriteNode

class PictureNode: SKSpriteNode {
    
    // MARK: Touch Methods
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
    
}

// MARK: PictureNode: EventListenerNode

extension PictureNode: EventListenerNode {
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let pictureNode = SKSpriteNode(imageNamed: "picture")
        let maskNode = SKSpriteNode(imageNamed: "picture-frame-mask")
        
        let cropNode = SKCropNode()
        cropNode.addChild(pictureNode)
        cropNode.maskNode = maskNode
        addChild(cropNode)
    }
}

// MARK: PictureNode: InteractiveNode

extension PictureNode: InteractiveNode {
    func interact() {
        isUserInteractionEnabled = false
        physicsBody!.isDynamic = true
    }
}
