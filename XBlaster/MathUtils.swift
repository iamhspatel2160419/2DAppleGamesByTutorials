//
//  MathUtils.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

let pi = CGFloat.pi

func degreesToRadians(value: CGFloat) -> CGFloat {
    return value * (pi / 180)
}

func radiansToDegrees(value: CGFloat) -> CGFloat {
    return value * (180 / pi)
}
