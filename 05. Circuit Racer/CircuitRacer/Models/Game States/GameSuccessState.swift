//
//  GameSuccessState.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSuccessState: GameOverlayState {
    
    override var overlaySceneFileName: String {
        return "SuccessScene"
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameActiveState.Type
    }
}
