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

// MARK: Achievements

extension GameKitHelper {
    
    func reportAchievements(achievements: [GKAchievement], errorHandler: ((Error?) -> Void)? = nil) {
        guard gameCenterEnabled else { return }
        GKAchievement.report(achievements, withCompletionHandler: errorHandler)
    }
    
    
    
}

// MARK: GameKitHelper: GKGameCenterControllerDelegate

extension GameKitHelper: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
    
    func showGKGameCenterViewController(viewController: UIViewController) {
        guard gameCenterEnabled else { return }
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.present(gameCenterViewController, animated: true)
    }
    
}
