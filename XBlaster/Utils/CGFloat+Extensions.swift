//
//  CGFloat+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    
    // Converts a CGFloat from degrees to radians.
    func degreesToRadians() -> CGFloat {
        return self * (CGFloat.pi / 180.0)
    }
    
    // Converts a CGFloat from radians to degrees.
    func radiansToDegrees() -> CGFloat {
        return self * (180.0 / CGFloat.pi)
    }
    
    // Ensures that the float value stays between the given values, inclusive.
    func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    // Ensures that the float value stays between the given values, inclusive.
    mutating func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        self = clamped(min, max)
        return self
    }
    
    // Returns 1.0 if a floating point value is positive; -1.0 if it is negative.
    func sign() -> CGFloat {
        return (self >= 0.0) ? 1.0 : -1.0
    }
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    // Returns a random floating point number in the range min...max, inclusive.
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
    
    // Randomly returns either 1.0 or -1.0.
    static func randomSign() -> CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
}

// Returns the shortest angle between two angles. The result is always between -pi and pi.
func shortestAngleBetween(angle1: CGFloat, angle2: CGFloat) -> CGFloat {
    let twoPi = CGFloat.pi * 2.0
    var angle = (angle2 - angle1).truncatingRemainder(dividingBy: twoPi)
    if (angle >= CGFloat.pi) {
        angle = angle - twoPi
    }
    if (angle <= -CGFloat.pi) {
        angle = angle + twoPi
    }
    return angle
}

