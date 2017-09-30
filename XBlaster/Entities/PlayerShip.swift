//
//  PlayerShip.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class PlayerShip: Entity {
    
    init(entityPosition: CGPoint) {
        let entityTexture = PlayerShip.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "playerShip"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func generateTexture() -> SKTexture? {

        struct SharedTexture {
            static var texture = SKTexture()
            static var onceToken = "playerShip"
        }
        
        DispatchQueue.once(token: SharedTexture.onceToken) {
            let mainShip = SKLabelNode(fontNamed: "Arial")
            mainShip.name = "mainship"
            mainShip.fontSize = 40
            mainShip.fontColor = SKColor.white
            mainShip.text = "▲"

            let wings = SKLabelNode(fontNamed: "Arial")
            wings.name = "wings"
            wings.fontSize = 45
            wings.text = "< >"
            wings.fontColor = SKColor.white
            wings.position = CGPoint(x: 0, y: 10)
            wings.zRotation = CGFloat(180.0).degreesToRadians()
            
            mainShip.addChild(wings)

            let textureView = SKView()
            SharedTexutre.texture = textureView.texture(from: mainShip)!
            SharedTexutre.texture.filteringMode = .nearest
        }
        
        return SharedTexutre.texture
    }
}
