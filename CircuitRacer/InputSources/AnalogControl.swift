//
//  AnalogControl.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import UIKit

class AnalogControl: UIView {
    
    let baseCenter: CGPoint
    
    let knobImageView: UIImageView
    let baseImageView: UIImageView
    
    var knobImageName: String = "knob" {
        didSet {
            knobImageView.image = UIImage(named: knobImageName)
        }
    }
    
    var baseImageName: String = "base" {
        didSet {
            baseImageView.image = UIImage(named: baseImageName)
        }
    }
    
    var delegate: InputControlProtocol?
    
    override init(frame: CGRect) {
        
        baseCenter = CGPoint(x: frame.size.width/2,
                             y: frame.size.height/2)
        
        knobImageView = UIImageView(image:  UIImage(named: knobImageName))
        knobImageView.frame.size.width /= 2
        knobImageView.frame.size.height /= 2
        knobImageView.center = baseCenter
        
        baseImageView = UIImageView(image: UIImage(named: baseImageName))
        
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
        
        baseImageView.frame = bounds
        addSubview(baseImageView)
        
        addSubview(knobImageView)
        
        assert(bounds.contains(knobImageView.bounds),
               "Analog control should be larger than the knob in size")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func updateKnobWithPosition(position: CGPoint) {
        
        var positionToCenter = position - baseCenter
        var direction: CGPoint
        
        if positionToCenter == CGPoint.zero {
            direction = CGPoint.zero
        } else {
            direction = positionToCenter.normalized()
        }
        
        
        let radius = frame.size.width/2
        var length = positionToCenter.length()
        
        
        if length > radius {
            length = radius
            positionToCenter = direction * radius
        }
        
        let relPosition = CGPoint(x: direction.x * (length/radius),
                                  y: direction.y * (length/radius) * -1)
        
        knobImageView.center = baseCenter + positionToCenter
        delegate?.directionChangedWithMagnitude(position: relPosition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            updateKnobWithPosition(position: touchLocation)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            updateKnobWithPosition(position: touchLocation)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateKnobWithPosition(position: baseCenter)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        updateKnobWithPosition(position: baseCenter)
    }
}
