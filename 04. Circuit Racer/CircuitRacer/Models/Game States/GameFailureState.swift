//
//  GameFailureState.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameFailureState: GameOverlayState {
    
    override var overlaySceneFileName: String {
        return "FailureScene"
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return false
    }
}
