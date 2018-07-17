//
//  CatNode.swift
//  CatNap
//
//  Created by Neil Hiddink on 7/9/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

// MARK: CatNode: SKSpriteNode

class CatNode: SKSpriteNode {
    
    // MARK: Properties
    
    static let kCatTappedNotification = "kCatTappedNotification"
    
    // MARK: Touch Methods
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}

// MARK: CatNode: EventListenerNode

extension CatNode: EventListenerNode {

    func didMoveToScene() {
        // print("Cat added to scene")
        
        isUserInteractionEnabled = true
        
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture, size: catBodyTexture.size())
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge | PhysicsCategory.Spring
        parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
    }
    
    func wakeUp() {

        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clear

        let catAwake = SKSpriteNode(
            fileNamed: "CatWakeUp")!.childNode(withName: "cat_awake")!

        catAwake.move(toParent: self)
        catAwake.position = CGPoint(x: -30, y: 100)
    }
    
    func curlAt(scenePoint: CGPoint) {
        
        parent!.physicsBody = nil
        
        for child in children {
            child.removeFromParent()
        }
        
        texture = nil
        color = SKColor.clear
        
        let catCurl = SKSpriteNode(
            fileNamed: "CatCurl")!.childNode(withName: "cat_curl")!
        
        catCurl.move(toParent: self)
        catCurl.position = CGPoint(x: -30, y: 100)
        
        var localPoint = parent!.convert(scenePoint, from: scene!)
        localPoint.y += frame.size.height/3
        
        run(SKAction.group([
            SKAction.move(to: localPoint, duration: 0.66),
            SKAction.rotate(toAngle: -parent!.zRotation, duration: 0.5)
            ]))
    }
    
}

extension CatNode: InteractiveNode {
    func interact() {
        NotificationCenter.default.post(Notification(name: NSNotification.Name(CatNode.kCatTappedNotification)))
    }
}
