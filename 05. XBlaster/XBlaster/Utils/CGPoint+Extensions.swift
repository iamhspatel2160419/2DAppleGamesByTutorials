//
//  CGPoint+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import CoreGraphics
import SpriteKit

extension CGPoint {
    
    // Creates a new CGPoint given a CGVector.
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    // Given an angle in radians, creates a vector of length 1.0 and returns the
    // result as a new CGPoint. An angle of 0 is assumed to point to the right.
    func pointFromAngle(angle: CGFloat) -> CGPoint {
        return CGPoint(x: cos(angle), y: sin(angle))
    }

    // Adds (dx, dy) to a point
    mutating func offset(dx: CGFloat, dy: CGFloat) -> CGPoint {
        x += dx
        y += dy
        return self
    }

    // Distance formula. Returns length (magnitude) of a vector described by a CGPoint.
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }

    // Returns the squared length of the vector described by the CGPoint.
    func lengthSquared() -> CGFloat {
        return x*x + y*y
    }
    
    // Performs distance action for length() formula
    func distanceTo(point: CGPoint) -> CGFloat {
        return (self - point).length()
    }

    // Returns the result of the normalized vector described by CGPoint to a length of 1.0 as a CGPoint.
    func normalized() -> CGPoint {
        let len = length()
        return len > 0 ? self / len : CGPoint.zero
    }

    // Performs normalization action for normalized() function.
    mutating func normalize() -> CGPoint {
        self = normalized()
        return self
    }

    // Returns the angle in radians of the vector described by the CGPoint.
    // The range of the angle is -pi to pi; an angle of 0 points to the right.
    var angle: CGFloat {
        return atan2(y, x)
    }

}

// MARK: CGPoint Operators

// MARK:---Addition

// Adds two CGPoint values and return the resulting CGPoint value.
func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

// Increments a CGPoint with another specified CGPoint value.
func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

// Adds a CGVector to a specified CGPoint and returns the result as a new CGPoint.
func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

// Increments a CGPoint with a specified CGVector value.
func += (left: inout CGPoint, right: CGVector) {
    left = left + right
}

// MARK:---Subtraction

// Subtracts two CGPoint values and returns the result as a new CGPoint.
func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

// Decrements a CGPoint with the value of another.
func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

// Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

// Decrements a CGPoint with the value of a CGVector.
func -= (left: inout CGPoint, right: CGVector) {
    left = left - right
}

// MARK:---Multiplication

// Multiplies two CGPoint values and returns the result as a new CGPoint.
func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

// Multiplies a CGPoint with another.
func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

// Multiplies the x and y fields of a CGPoint with the same scalar value and returns the result as a new CGPoint.
func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

// Multiplies the x and y fields of a CGPoint with the same scalar value.
func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

//
// Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

// Multiplies a CGPoint with a CGVector.
func *= (left: inout CGPoint, right: CGVector) {
    left = left * right
}

// MARK:---Division

// Divides two CGPoint values and returns the result as a new CGPoint.
func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

// Divides a CGPoint by another.
func /= (left: inout CGPoint, right: CGPoint) {
    left = left / right
}

// Divides the x and y fields of a CGPoint by the same scalar value and returns the result as a new CGPoint.
func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

// Divides the x and y fields of a CGPoint by the same scalar value.
func /= (point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

// Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

// Divides a CGPoint by a CGVector.
func /= (left: inout CGPoint, right: CGVector) {
    left = left / right
}

// MARK:---Linear Interpolation
func linearInterpolation(start: CGPoint, end: CGPoint, t: CGFloat) -> CGPoint {
    return CGPoint(x: start.x + (end.x - start.x) * t, y: start.y + (end.y - start.y) * t)
}

