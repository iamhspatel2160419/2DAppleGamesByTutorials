//
//  SKColor+Extensions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/26/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//


import SpriteKit

func SKColorWithRGB(r: Int, g: Int, b: Int) -> SKColor {
  return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

func SKColorWithRGBA(r: Int, g: Int, b: Int, a: Int) -> SKColor {
  return SKColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
}
