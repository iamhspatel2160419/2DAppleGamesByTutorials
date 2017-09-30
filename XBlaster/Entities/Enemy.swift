//
//  Enemy.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/29/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

// The different enemies in XBlaster all share the same behaviors such as how they move using
// AISteering, their health labels and how they react to being hit. This base class immplements
// these key areas which all the enemy objects can then inherit from.
class Enemy : Entity {
    
    let healthMeterLabel = SKLabelNode(fontNamed: "Arial")
    let healthMeterText: String? = "________"
    let scoreLabel = SKLabelNode(fontNamed: "Edit Undo Line BRK")
    let damageTakenPerHit = 10.0
    
    var aiSteering: AISteering!
    var playableRect: CGRect!
    var dead = false
    var score = 0
    
    // All the actions used for the enemies are static which means that each enemy uses a shared
    // action that is created only once in the loadSharedAssets() method. This reduces the number
    // of actions needed and removes the need to keep creating and destroying actions for each enemy
    struct SharedAssets {
        static var damageAction:SKAction!
        static var hitLeftAction:SKAction!
        static var hitRightAction:SKAction!
        static var moveBackAction:SKAction!
        static var scoreLabelAction:SKAction!
        static var onceToken = "Enemy"
    }
    
    class func loadSharedAssets() {
        
        // See extension in Entity.swift
        DispatchQueue.once(token: SharedAssets.onceToken) {
            
            SharedAssets.damageAction = SKAction.sequence([
                SKAction.colorize(with: SKColor.red, colorBlendFactor: 1.0, duration: 0.0),
                SKAction.colorize(withColorBlendFactor: 0.0, duration: 1.0)
                ])
            
            SharedAssets.hitLeftAction = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(-15).degreesToRadians(), duration: 0.25),
                SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0.5)
                ])
            
            SharedAssets.hitRightAction = SKAction.sequence([
                SKAction.rotate(byAngle: CGFloat(15).degreesToRadians(), duration: 0.25),
                SKAction.rotate(toAngle: CGFloat(0).degreesToRadians(), duration: 0.5)
                ])
            
            SharedAssets.moveBackAction = SKAction.moveBy(x: 0, y: 20, duration: 0.25)
            
            SharedAssets.scoreLabelAction = SKAction.sequence([
                SKAction.group([
                    SKAction.scale(to: 1, duration: 0),
                    SKAction.fadeOut(withDuration: 0),
                    SKAction.fadeIn(withDuration: 0.5),
                    SKAction.moveBy(x: 0, y: 20, duration: 0.5)
                    ]),
                SKAction.group([
                    SKAction.moveBy(x: 0, y: 40, duration: 1),
                    SKAction.fadeOut(withDuration: 1)
                    ]),
                ])
        }
  
    }
    
    init(entityPosition: CGPoint, texture: SKTexture, playableRect: CGRect) {
        
        super.init(position: entityPosition, texture: texture)
        
        self.playableRect = playableRect
        
        // Setup the label that shows how much health an enemy has
        healthMeterLabel.name = "healthMeter"
        healthMeterLabel.fontSize = 20
        healthMeterLabel.fontColor = SKColor.green
        healthMeterLabel.text = healthMeterText
        healthMeterLabel.position = CGPoint(x: 0, y: 30)
        addChild(healthMeterLabel)
        
        scoreLabel.fontSize = 15
        scoreLabel.color = SKColorWithRGBA(r: 128, g: 255, b: 255, a: 255)
        scoreLabel.text = String(score)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func update(delta: TimeInterval) {
        
        // If the player has been marked as dead then reposition them at the top of the screen and
        // mark them a no longer being dead
        if dead {
            dead = false
            position = CGPoint(x: CGFloat.random(min: playableRect.origin.x, max: playableRect.size.width), y: playableRect.size.height)
        }
        
        // If the enemy has reached is next waypoint then set the next waypoint to the players
        // current position. This causes the enemies to chase the player :]
        if aiSteering.waypointReached {
            let mainScene = scene as! GameScene
            aiSteering.updateWaypoint(waypoint: mainScene.playerShip.position)
        }
        
        // Steer the enemy towards the current waypoint
        aiSteering.update(delta: delta)
        
        // Update the health meter for the enemy
        var healthBarLength = 8.0 * health / 100
        let index = 
        healthMeterLabel.text = "\(String(healthMeterLabel[..<(Int(healthBarLength))]))"
        
        healthMeterLabel.fontColor = SKColor(red: CGFloat(2 * (1 - health / 100)),
                                             green:CGFloat(2 * health / 100), blue:0, alpha:1)
    }
    
    func configureCollisionBody() {
        // More details on this method inside the PlayerShip class and more details on SpriteKit physics in
        // Chapter 9, "Beginner Physics"
        physicsBody = SKPhysicsBody(rectangleOf: frame.size)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = ColliderType.Enemy
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = ColliderType.Player | ColliderType.Bullet
    }
    
    override func collidedWith(body: SKPhysicsBody, contact: SKPhysicsContact) {
        
        // When an enemy gets hit we grab the point at which the enemy was hit
        let localContactPoint:CGPoint = self.scene!.convert(contact.contactPoint, to: self)
        
        // New actions are going to be added to this enemy so remove all the current actions they have
        removeAllActions()
        
        // If the enemy was hit on the left side then run the hitLeftAction otherwise run the hitRightAction.
        // This gives a nice impression of an actual collision
        if localContactPoint.x < 0 {
            run(SharedAssets.hitLeftAction)
        } else {
            run(SharedAssets.hitRightAction)
        }
        
        // Run the damage action so that the player has a visual que that the enemy has been damaged
        run(SharedAssets.damageAction)
        if aiSteering.currentDirection.y < 0 {
            run(SharedAssets.moveBackAction)
        }
        
        // Reduce the enemies health by the defined damageTakenPerHit
        health -= damageTakenPerHit
        
        // If the enemies health is now zero or less, then...
        if health <= 0 {
            // ...mark them as dead
            dead = true
            
            // Increase the score for the player
            let mainScene = scene as! GameScene
            mainScene.increaseScoreBy(score)
            
            // Reset the enemies health
            health = maxHealth
            
            scoreLabel.position = position
            if scoreLabel.parent == nil {
                mainScene.addChild(scoreLabel)
            }
            scoreLabel.removeAllActions()
            scoreLabel.run(SharedAssets.scoreLabelAction)
            
        }
    }
}
