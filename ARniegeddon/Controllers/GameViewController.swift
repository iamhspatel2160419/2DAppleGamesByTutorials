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
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ARSKView {
            sceneView = view
            sceneView!.delegate = self
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

// MARK: GameViewController: ARSKViewDelegate

extension GameViewController: ARSKViewDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        print("Session Failed - probably due to lack of camera access")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("Session resumed")
        sceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        var node: SKNode?
        if let anchor = anchor as? Anchor {
            if let type = anchor.type {
                node = SKSpriteNode(imageNamed: type.rawValue)
                node?.name = type.rawValue
            }
        }
        return node
    }

}
