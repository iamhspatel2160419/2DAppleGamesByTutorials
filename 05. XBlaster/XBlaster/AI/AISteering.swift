//
//  AISteering.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/29/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import SpriteKit

// This small class implements something called Autonomous Steering. It is an approach to
// steering objects in a natural feeling way. This class implements the Seek steering behavior.
// Detailed information on the Seek behavior and other steering behaviors can be found at
// http://www.red3d.com/cwr/steer/SeekFlee.html
class AISteering {
    
    weak var entity: Entity!
    var maxVelocity: CGFloat = 10.0
    var maxSteeringForce: CGFloat = 0.06
    var waypointRadius: CGFloat = 50.0
    var waypoint:CGPoint = CGPoint.zero
    var currentPosition = CGPoint.zero
    var currentDirection = CGPoint.zero
    var waypointReached = false
    var faceDirectionOfTravel = false
    
    init(entity: Entity, waypoint: CGPoint) {
        self.entity = entity
        self.waypoint = waypoint
    }
    
    func update(delta:CFTimeInterval) {
        
        // Get the entities current position
        currentPosition = entity.position
        
        // Work out the vector to the current waypoint from the entities current position
        var desiredDirection:CGPoint = waypoint - currentPosition
        
        // Calculate the distance from the entity to the waypoint
        var distanceToWaypoint:CGFloat = desiredDirection.length()
        
        // Update the desired location of the entity based on the maxVelocity that has been
        // defined and the distance to the waypoint
        desiredDirection = desiredDirection * maxVelocity / distanceToWaypoint
        
        // Calculate the steering force needed to turn towards the waypoint. We turn the entity over
        // time based on the maxSteeringForce to get a natural steering movement rather than snap
        // immediately to point directly towards the waypoint
        var force:CGPoint = desiredDirection - currentDirection
        var steeringForce:CGPoint = force * maxSteeringForce / maxVelocity
        
        // Calculate the new direction the entity should move in based on the current direction
        // and the maximum steering force that can be applied. A higher steering force will cause
        // the entity to turn more quickly
        currentDirection = currentDirection + steeringForce
        
        // Calculate the entities new position by adding it's newly calculated current direction to its
        // current position and then set that as the entities position
        currentPosition = currentPosition + currentDirection
        entity.position = currentPosition
        
        // If the new position is within the defined waypoint radius then mark the waypoint as reached.
        // The smaller the waypointRadius the longer it will take for the entity to reach it as it will
        // over shoot the waypoint and keep turning back until it gets with the waypointRaius from the
        // waypoint
        if distanceToWaypoint < waypointRadius {
            waypointReached = true
        }
    }
    
    // This method is used to set a new waypoint for the entity to steer towards
    func updateWaypoint(waypoint:CGPoint) {
        self.waypoint = waypoint
        waypointReached = false
    }
}

