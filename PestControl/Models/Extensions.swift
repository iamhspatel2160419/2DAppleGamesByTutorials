//
//  Extensions.swift
//  PestControl
//
//  Created by Neil Hiddink on 7/22/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import SpriteKit

extension SKTexture {
    convenience init(pixelImageNamed: String) {
        self.init(imageNamed: pixelImageNamed)
        self.filteringMode = .nearest
    }
}
