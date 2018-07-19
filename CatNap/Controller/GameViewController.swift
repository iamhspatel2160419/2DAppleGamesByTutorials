//
//  GameViewController.swift
//  Cat Nap
//
//  Created by Neil Hiddink on 10/2/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

// MARK: GameViewController: UIViewController

class GameViewController: UIViewController {

    // MARK: Properties
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = GameScene.level(levelNum: 3) {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.showsPhysics = true
            view.ignoresSiblingOrder = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

}
