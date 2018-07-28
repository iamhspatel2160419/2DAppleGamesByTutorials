//
//  GameScene+Buttons.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import Foundation

extension GameScene: ButtonNodeResponder {
    
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allIdentifiers.flatMap { buttonIdentifier in
            return childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
    
    func buttonPressed(button: ButtonNode) {
        SKTAudio.sharedInstance().playSoundEffect("button_press.wav")
        switch button.buttonIdentifier! {
        case .resume:
            stateMachine.enter(GameActiveState.self)
        case .cancel:
            gameSceneDelegate?.didSelectCancelButton(gameScene: self)
        case .replay:
            stateMachine.enter(GameActiveState.self)
        case .pause:
            stateMachine.enter(GamePauseState.self)
        }
    }
}
