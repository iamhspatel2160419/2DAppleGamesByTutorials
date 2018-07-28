//
//  GameViewController.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK: Properties
    
    var carType: CarType!
    var levelType: LevelType!
    
    var gameScene: GameScene!
    var analogControl: AnalogControl?
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed:"GameScene") {
            
            gameScene = scene
            gameScene.gameSceneDelegate = self
            
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .aspectFill
            scene.levelType = levelType
            scene.carType = carType
            
            skView.presentScene(scene)
            
            let analogControlSize: CGFloat = view.frame.size.height / 2.5
            let analogControlPadding: CGFloat = view.frame.size.height / 32
            
            analogControl = AnalogControl(frame: CGRect(origin: CGPoint(x: analogControlPadding, y: skView.frame.size.height - analogControlPadding - analogControlSize), size: CGSize(width: analogControlSize, height: analogControlSize)))
            analogControl?.delegate = scene
            view.addSubview(analogControl!)
        }
    }
}

extension GameViewController: GameSceneProtocol {
    func didSelectCancelButton(gameScene: GameScene) {
        _ = navigationController?.popToRootViewController(animated: false)
    }
    
    func didShowOverlay(gameScene: GameScene) {
        analogControl?.isHidden = true
    }
    
    func didDismissOverlay(gameScene: GameScene) {
        analogControl?.isHidden = false
    }
}
