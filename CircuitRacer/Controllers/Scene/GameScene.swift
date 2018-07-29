//
//  GameScene.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

protocol GameSceneProtocol: class {
    func didSelectCancelButton(gameScene: GameScene)
    func didShowOverlay(gameScene: GameScene)
    func didDismissOverlay(gameScene: GameScene)
}

// MARK: GameScene: SKScene

class GameScene: SKScene {
    
    // MARK: Properties
    
    weak var gameSceneDelegate: GameSceneProtocol?
    
    var carType: CarType!
    var levelType: LevelType!
    
    var lastUpdateTimeInterval: TimeInterval = 0
    
    var box1: SKSpriteNode!, box2: SKSpriteNode!
    var laps: SKLabelNode!, time: SKLabelNode!
    
    var maxSpeed = 0
    
    var lapSoundAction: SKAction!, boxSoundAction: SKAction!
    
    private var buttons: [ButtonNode] = []
    
    var overlay: SceneOverlay? {
        didSet {
            
            buttons = []
            oldValue?.backgroundNode.removeFromParent()
            
            if let overlay = overlay, let camera = camera {
                overlay.backgroundNode.position.y = -overlapAmount()/2
                camera.addChild(overlay.backgroundNode)
                
                buttons = findAllButtonsInScene()
                
                gameSceneDelegate?.didShowOverlay(gameScene: self)
            } else {
                gameSceneDelegate?.didDismissOverlay(gameScene: self)
            }
        }
    }
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameActiveState(gameScene: self),
        GamePauseState(gameScene: self),
        GameFailureState(gameScene: self),
        GameSuccessState(gameScene: self)
    ])
    
    var noOfCollisions = 0
    static let CarCategoryMask: UInt32 = 1
    static let BoxCategoryMask: UInt32 = 2
    
    // MARK: Scene Life Cycle
    
    override func didMove(to view: SKView) {
        
        setupPhysicsBodies()
        
        ButtonNode.parseButtonInNode(containerNode: self)
        
        let pauseButton = childNode(withName: "pause") as! SKSpriteNode
        pauseButton.anchorPoint = .zero
        pauseButton.position = CGPoint(x: size.width - pauseButton.size.width, y: size.height - pauseButton.size.height - overlapAmount()/2)
        
        boxSoundAction = SKAction.playSoundFileNamed("box.wav",
                                                     waitForCompletion: false)
        lapSoundAction = SKAction.playSoundFileNamed("lap.wav",
                                                     waitForCompletion: false)
        
        box1 = (childNode(withName: "box_1") as! SKSpriteNode)
        box2 = (childNode(withName: "box_2") as! SKSpriteNode)
        
        laps = (self.childNode(withName: "laps_label") as! SKLabelNode)
        time = (self.childNode(withName: "time_left_label") as! SKLabelNode)
        
        let camera = SKCameraNode()
        scene?.camera = camera
        scene?.addChild(camera)
        setCameraPosition(position: CGPoint(x: size.width/2, y: size.height/2))
        
        stateMachine.enter(GameActiveState.self)
        
        childNode(withName: "car")?.physicsBody?.contactTestBitMask = GameScene.BoxCategoryMask
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        let deltaTime = currentTime - lastUpdateTimeInterval
        stateMachine.update(deltaTime: deltaTime)
    }
    
    // MARK: Private Methods
    
    private func setupPhysicsBodies() {
        let innerBoundary = SKNode()
        
        let track = childNode(withName: "track")!
        innerBoundary.position = CGPoint(x: track.position.x + track.frame.size.width/2, y: track.position.y + track.frame.size.height/2)
        
        addChild(innerBoundary)
        
        innerBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 720, height: 480))
        innerBoundary.physicsBody!.isDynamic = false
        
        let trackFrame = childNode(withName: "track")!.frame.insetBy(dx: 200, dy: 0)
        
        let maxAspectRatio: CGFloat = 3.0/2.0 // iPhone 4
        let maxAspectRatioHeight = trackFrame.size.width / maxAspectRatio
        let playableMarginY: CGFloat = (trackFrame.size.height - maxAspectRatioHeight)/2
        let playableMarginX: CGFloat = (frame.size.width - trackFrame.size.width)/2
        
        let playableRect = CGRect(x: playableMarginX,
                                  y: playableMarginY,
                                  width: trackFrame.size.width,
                                  height: trackFrame.size.height - playableMarginY*2)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
    }
    
    private func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0
        }
        let scale = view.bounds.size.width / self.size.width
        let scaledHeight = self.size.height * scale
        let scaledOverlap = scaledHeight - view.bounds.size.height
        return scaledOverlap / scale
    }
    
    private func setCameraPosition(position: CGPoint) {
        scene?.camera?.position = CGPoint(x: position.x, y: position.y)
    }
    
    func reportAllAchievementsForGameState(hasWon: Bool) {
        var achievements: [GKAchievement] = []
        achievements.append(AchievementsHelper.collisionAchievement(noOfCollisions: noOfCollisions))
        if hasWon {
            achievements.append(AchievementsHelper.achievementForLevel(levelType: levelType))
        }
        AchievementsHelper.numberOfRacesCompleted += 1
        achievements.append(AchievementsHelper.racingAddictAchievement(plays: AchievementsHelper.numberOfRacesCompleted))
        GameKitHelper.sharedInstance.reportAchievements(achievements: achievements)
    }
}

// MARK: GameScene: InputControlProtocol

extension GameScene: InputControlProtocol {
    func directionChangedWithMagnitude(position: CGPoint) {
        if isPaused {
            return
        }
        
        if let car = self.childNode(withName: "car") as? SKSpriteNode, let carPhysicsBody = car.physicsBody {
            
            carPhysicsBody.velocity = CGVector(
                dx: position.x * CGFloat(maxSpeed),
                dy: position.y * CGFloat(maxSpeed))
            
            if position != CGPoint.zero {
                car.zRotation = CGPoint(x: position.x, y: position.y).angle
            }
        }
    }
}

// MARK: GameScene: SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask != UInt32.max &&
           contact.bodyB.categoryBitMask != UInt32.max &&
           (contact.bodyA.categoryBitMask + contact.bodyB.categoryBitMask ==
            GameScene.CarCategoryMask + GameScene.BoxCategoryMask) {
            noOfCollisions += 1
            run(boxSoundAction)
        }
    }
}
