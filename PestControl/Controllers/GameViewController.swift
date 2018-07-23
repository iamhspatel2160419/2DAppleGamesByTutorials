//
//  GameViewController.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/15/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {

            if let scene = SKScene(fileNamed: "GameScene") {

                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            /*
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
            */
        }
    }
    
}

