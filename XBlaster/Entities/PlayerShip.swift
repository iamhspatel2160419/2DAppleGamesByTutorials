//
//  PlayerShip.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

struct SharedTexture {
    static var texture = SKTexture()
    init() {
    }
}


class PlayerShip: Entity {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(entityPosition: CGPoint) {
        let entityTexture = PlayerShip.generateTexture()!
        super.init(position: entityPosition, texture: entityTexture)
        name = "playerShip"
    }
    
    override class func generateTexture() -> SKTexture? {

        let mainShip = SKLabelNode(fontNamed: "Arial")
        mainShip.name = "mainship"
        mainShip.fontSize = 40
        mainShip.fontColor = SKColor.white
        mainShip.text = "▲"

        let wings = SKLabelNode(fontNamed: "Arial")
        wings.name = "wings"
        wings.fontSize = 50
        wings.text = "⇥ ⇤"
        wings.fontColor = SKColor.white
        wings.position = CGPoint(x: 0, y: 20)

        wings.zRotation = CGFloat(180.0).degreesToRadians()
        mainShip.addChild(wings)

        let textureView = SKView()
        SharedTexture.texture = textureView.texture(from: mainShip)!
        SharedTexture.texture.filteringMode = .nearest

        return SharedTexture.texture
    }
}
