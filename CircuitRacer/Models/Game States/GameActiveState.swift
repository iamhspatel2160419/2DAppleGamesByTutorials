//
//  GameActiveState.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameActiveState: GKState {
    
    unowned let gameScene: GameScene
    
    private var timeInSeconds = 0
    private var numberOfLaps = 0
    private var trackCenter = CGPoint.zero
    private var nextProgressAngle = Double.pi
    
    private var previousTimeInterval: TimeInterval = 0
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        super.init()
        
        initializeGame()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GamePauseState.Type, is GameFailureState.Type, is GameSuccessState.Type:
            return true
        default:
            return false
        }
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        if previousState is GameSuccessState {
            restartLevel()
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if previousTimeInterval == 0 {
            previousTimeInterval = seconds
        }
        
        if gameScene.isPaused {
            previousTimeInterval = seconds
            return
        }
        
        if seconds - previousTimeInterval >= 1 {
            timeInSeconds -= 1
            previousTimeInterval = seconds
            
            if timeInSeconds >= 0 {
                updateLabels()
            }
        }
        
        let carPosition = gameScene.childNode(withName: "car")!.position
        let vector = carPosition - trackCenter
        let progressAngle = Double(vector.angle) + Double.pi
        
        //1
        if progressAngle > nextProgressAngle
            && (progressAngle - nextProgressAngle) < Double.pi/4 {
            
            //2
            nextProgressAngle += Double.pi/2
            
            //3
            if nextProgressAngle >= (2 * Double.pi) {
                nextProgressAngle = 0
            }
            
            //4
            if fabs(nextProgressAngle - Double.pi) < Double(Float.ulpOfOne) {
                //lap completed!
                numberOfLaps -= 1
                
                updateLabels()
                gameScene.run(gameScene.lapSoundAction)
            }
        }
        
        if timeInSeconds < 0 || numberOfLaps == 0 {
            if numberOfLaps == 0 {
                stateMachine?.enter(GameSuccessState.self)
            } else {
                stateMachine?.enter(GameFailureState.self)
            }
        }
    }
    
    // MARK: Private methods
    private func initializeGame() {
        
        loadLevel()
        loadTrackTexture()
        loadCarTexture()
        updateLabels()
        
        gameScene.maxSpeed = 500 * (2 + gameScene.carType.rawValue)
        
        let track = gameScene.childNode(withName: "track") as! SKSpriteNode
        trackCenter = CGPoint(x: track.size.width/2, y: track.size.height/2)
    }
    
    private func restartLevel() {
        loadLevel()
        updateLabels()
        
        let car = gameScene.childNode(withName: "car") as! SKSpriteNode
        car.position = CGPoint(x: 884, y: 442)
        car.resetPhysicsForcesAndVelocity()
        
        gameScene.box1.resetPhysicsForcesAndVelocity()
        gameScene.box2.resetPhysicsForcesAndVelocity()
        
        gameScene.box1.position = CGPoint(x: 1722, y: 762)
        gameScene.box2.position = CGPoint(x: 314, y: 746)
    }
    
    private func loadLevel() {
        let filePath = Bundle.main.path(
            forResource: "LevelDetails", ofType: "plist")!
        
        let levels = NSArray(contentsOfFile: filePath)!
        
        let levelData = levels[gameScene.levelType.rawValue] as! NSDictionary
        
        timeInSeconds = levelData["time"] as! Int
        numberOfLaps = levelData["laps"] as! Int
    }
    
    private func loadTrackTexture() {
        if let track  = gameScene.childNode(withName: "track") as? SKSpriteNode {
            track.texture = SKTexture(imageNamed:
                "track_\(gameScene.levelType.rawValue + 1)")
        }
    }
    
    private func loadCarTexture() {
        if let car = gameScene.childNode(withName: "car") as? SKSpriteNode {
            car.texture = SKTexture(imageNamed:
                "car_\(gameScene.carType.rawValue + 1)")
        }
    }
    
    private func updateLabels() {
        gameScene.laps.text = "Laps: \(numberOfLaps)"
        gameScene.time.text = "Time: \(timeInSeconds)"
    }
}
