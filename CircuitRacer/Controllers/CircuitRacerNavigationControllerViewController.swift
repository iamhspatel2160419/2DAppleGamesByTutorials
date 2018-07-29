//
//  CircuitRacerNavigationControllerViewController.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/29/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit

// MARK: CircuitRacerNavigationControllerViewController: UINavigationController

class CircuitRacerNavigationControllerViewController: UINavigationController {

    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showAuthenticationViewController),
                                               name: NSNotification.Name(GameKitHelper.PresentAuthenticationViewController),
                                               object: nil)
        GameKitHelper.sharedInstance.authenticateLocalPlayer()
    }

    // MARK: Helper Methods
    
    @objc func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        if let authenticationViewController = gameKitHelper.authenticationViewController {
            topViewController?.present(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: Deinitialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
