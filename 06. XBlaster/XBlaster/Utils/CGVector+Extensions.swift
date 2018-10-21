//
//  CGVector+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import CoreGraphics
import SpriteKit

extension CGVector {
    
    // Creates a new CGVector given a CGPoint.
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
    // Given an angle in radians, creates a vector of length 1.0 and returns the
    // result as a new CGVector. An angle of 0 is assumed to point to the right.
    func unitVectorFromAngle(angle: CGFloat) -> CGVector {
        return CGVector(dx: cos(angle), dy: sin(angle))
    }
    
    // Adds (dx, dy) to the vector.
    mutating func offset(dx: CGFloat, dy: CGFloat) -> CGVector {
        self.dx += dx
        self.dy += dy
        return self
    }
    
    // Distance formula. Returns length (magnitude) of a vector described by a CGVector.
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    // Returns the squared length of the vector described by the CGVector.
    func lengthSquared() -> CGFloat {
        return dx*dx + dy*dy
    }
    
    // Normalizes the vector described by the CGVector to length 1.0 and returns the result as a new CGVector.
    func normalized() -> CGVector {
        let len = length()
        return len > 0 ? self / len : CGVector.zero
    }
    
    // Performs normalization action for normalized() function.
    mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }
    
    // Performs distance action for length() formula
    func distanceTo(vector: CGVector) -> CGFloat {
        return (self - vector).length()
    }
    
    // Returns the angle in radians of the vector described by the CGVector.
    // The range of the angle is -pi to pi; an angle of 0 points to the right.
    var angle: CGFloat {
        return atan2(dy, dx)
    }

}

// MARK: CGVector Operators

// MARK:---Addition

// Adds two CGVector values and returns the result as a new CGVector.
func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

// Increments a CGVector with the value of another.
func += (left: inout CGVector, right: CGVector) {
    left = left + right
}

// MARK:---Subtraction

// Subtracts two CGVector values and returns the result as a new CGVector.
func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

// Decrements a CGVector with the value of another.
func -= (left: inout CGVector, right: CGVector) {
    left = left - right
}

// MARK:---Multiplication

// Multiplies two CGVector values and returns the result as a new CGVector.
func * (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

// Multiplies a CGVector with another.
func *= (left: inout CGVector, right: CGVector) {
    left = left * right
}

// Multiplies the x and y fields of a CGVector with the same scalar value and returns the result as a new CGVector.
func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

// Multiplies the x and y fields of a CGVector with the same scalar value.
func *= (vector: inout CGVector, scalar: CGFloat) {
    vector = vector * scalar
}

// MARK:---Division

// Divides two CGVector values and returns the result as a new CGVector.
func / (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

// Divides a CGVector by another.
func /= (left: inout CGVector, right: CGVector) {
    left = left / right
}

// Divides the dx and dy fields of a CGVector by the same scalar value and returns the result as a new CGVector.
func / (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

// Divides the dx and dy fields of a CGVector by the same scalar value.
func /= (vector: inout CGVector, scalar: CGFloat) {
    vector = vector / scalar
}

// MARK:---Linear Interpolation

// Performs a linear interpolation between two CGVector values.
func linearInterpolation(start: CGVector, end: CGVector, t: CGFloat) -> CGVector {
    return CGVector(dx: start.dx + (end.dx - start.dx) * t, dy: start.dy + (end.dy - start.dy) * t)
}
