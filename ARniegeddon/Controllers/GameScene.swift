//
//  GameScene.swift
//  ARniegeddon
//
//  Created by Neil Hiddink on 6/6/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import ARKit

class GameScene: SKScene {
    
    // MARK: Properties
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    var isWorldSetUp = false
    
    // MARK: Scene Life Cycle
    
    override func update(_ currentTime: TimeInterval) {
        if !isWorldSetUp {
            setUpWorld()
        }
        
        guard let currentFrame = sceneView.session.currentFrame,
              let lightEstimate = currentFrame.lightEstimate else { return }
        
        let neutralIntensity: CGFloat = 1000
        let ambientIntensity = min(lightEstimate.ambientIntensity, neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity

        for node in children {
            if let bug = node as? SKSpriteNode {
                bug.color = .black
                bug.colorBlendFactor = blendFactor
            }
        }
    }
    
    // MARK: Private Methods
    
    private func setUpWorld() {
        guard let currentFrame = sceneView.session.currentFrame else { return }
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3
        let transform = currentFrame.camera.transform * translation
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
        isWorldSetUp = true
    }
    
}
