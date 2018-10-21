//
//  SceneOverlay.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

class SceneOverlay {
    
    let backgroundNode: SKSpriteNode
    let contentNode: SKSpriteNode
    let nativeContentSize: CGSize
    
    init(overlaySceneFileName fileName: String, zPosition: CGFloat) {
        
        let overlayScene = SKScene(fileNamed: fileName)
        let contentTemplateNode = overlayScene?.childNode(withName: "Overlay") as! SKSpriteNode
        
        backgroundNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size)
        backgroundNode.zPosition = zPosition
        
        contentNode = contentTemplateNode.copy() as! SKSpriteNode
        contentNode.position = .zero
        backgroundNode.addChild(contentNode)
        
        contentNode.color = .clear
        
        nativeContentSize = contentNode.size
    }
    
    func updateScale() {
        guard let viewSize = backgroundNode.scene?.view?.frame.size else {
            return
        }
        
        backgroundNode.size = viewSize
        
        let scale = viewSize.height/nativeContentSize.height
        contentNode.setScale(scale)
    }
}
