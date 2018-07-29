//
//  GameViewController.swift
//  ARniegeddon
//
//  Created by Neil Hiddink on 6/6/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import ARKit

// MARK: GameViewController: UIViewController

class GameViewController: UIViewController {
    
    // MARK: Properties
    
    var sceneView: ARSKView!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        
        if let view = self.view as? ARSKView {
            sceneView = view
        }
    }
    
}
