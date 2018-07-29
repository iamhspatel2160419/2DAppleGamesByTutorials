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
    
    var authenticateViewController: UIViewController?
    var gameCenterEnabled = false
}
