//
//  CarType.swift
//  CircuitRacer
//
//  Created by Neil Hiddink on 7/28/18.
//  Copyright © 2018 Neil Hiddink. All rights reserved.
//

import Foundation

enum CarType: Int, CustomStringConvertible {
    case yellow, blue, red
    
    var description: String {
        switch self {
        case .yellow:
            return "Yellow car"
        case .blue:
            return "Blue car"
        case .red:
            return "Red car"
        }
    }
}

