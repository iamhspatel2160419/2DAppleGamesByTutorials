//
//  Entity.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/25/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

class Entity : SKSpriteNode {

    var direction = CGPoint.zero
    var health = 100.0
    var maxHealth = 100.0
    
    init(position: CGPoint, texture: SKTexture) {
        super.init(texture: texture, color: SKColor.white, size: texture.size())
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func generateTexture() -> SKTexture? {
        // Overridden by subclasses
        return nil
    }

    func update(delta: TimeInterval) {
    
    }
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block: () -> ()) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
