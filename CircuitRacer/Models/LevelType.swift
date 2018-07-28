//
//  LevelType.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import Foundation

enum LevelType: Int, CustomStringConvertible {
    case easy, medium, hard
    
    var description: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }
}

