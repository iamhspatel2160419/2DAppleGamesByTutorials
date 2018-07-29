//
//  GameKitHelper.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/29/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit
import Foundation
import GameKit

class GameKitHelper: NSObject {
    
    static let sharedInstance = GameKitHelper()
    static let PresentAuthenticationViewController = "PresentAuthenticationViewController"
    
    var authenticationViewController: UIViewController?
    var gameCenterEnabled = false
    
    func authenticateLocalPlayer() {

        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) in
            self.gameCenterEnabled = false
            if viewController != nil {
                self.authenticationViewController = viewController
                NotificationCenter.default.post(name: NSNotification.Name(GameKitHelper.PresentAuthenticationViewController), object: self)
            } else if GKLocalPlayer.localPlayer().isAuthenticated {
                self.gameCenterEnabled = true
            }
        }
    }
}
