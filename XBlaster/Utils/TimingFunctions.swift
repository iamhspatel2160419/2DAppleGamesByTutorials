//
//  TimingFunctions.swift
//  XBlaster
//
//  Created by Neil Hiddink on 9/28/17.
//  Copyright © 2017 Neil Hiddink. All rights reserved.
//

import Foundation
import CoreGraphics

func TimingFunctionLinear(t: CGFloat) -> CGFloat {
    return t
}

func TimingFunctionQuadraticEaseIn(t: CGFloat) -> CGFloat {
    return t * t
}

func TimingFunctionQuadraticEaseOut(t: CGFloat) -> CGFloat {
    return t * (2.0 - t)
}

func TimingFunctionQuadraticEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 2.0 * t * t
    } else {
        let f = t - 1.0
        return 1.0 - 2.0 * f * f
    }
}

func TimingFunctionCubicEaseIn(t: CGFloat) -> CGFloat {
    return t * t * t
}

func TimingFunctionCubicEaseOut(t: CGFloat) -> CGFloat {
    let f = t - 1.0
    return 1.0 + f * f * f
}

func TimingFunctionCubicEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 4.0 * t * t * t
    } else {
        let f = t - 1.0
        return 1.0 + 4.0 * f * f * f
    }
}

func TimingFunctionQuarticEaseIn(t: CGFloat) -> CGFloat {
    return t * t * t * t
}

func TimingFunctionQuarticEaseOut(t: CGFloat) -> CGFloat {
    let f = t - 1.0
    return 1.0 - f * f * f * f
}

func TimingFunctionQuarticEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 8.0 * t * t * t * t
    } else {
        let f = t - 1.0
        return 1.0 - 8.0 * f * f * f * f
    }
}

func TimingFunctionQuinticEaseIn(t: CGFloat) -> CGFloat {
    return t * t * t * t * t
}

func TimingFunctionQuinticEaseOut(t: CGFloat) -> CGFloat {
    let f = t - 1.0
    return 1.0 + f * f * f * f * f
}

func TimingFunctionQuinticEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 16.0 * t * t * t * t * t
    } else {
        let f = t - 1.0
        return 1.0 + 16.0 * f * f * f * f * f
    }
}

func TimingFunctionSineEaseIn(t: CGFloat) -> CGFloat {
    return sin((t - 1.0) * CGFloat.pi / 2) + 1.0
}

func TimingFunctionSineEaseOut(t: CGFloat) -> CGFloat {
    return sin(t * CGFloat.pi / 2)
}

func TimingFunctionSineEaseInOut(t: CGFloat) -> CGFloat {
    return 0.5 * (1.0 - cos(t * CGFloat.pi))
}

func TimingFunctionCircularEaseIn(t: CGFloat) -> CGFloat {
    return 1.0 - sqrt(1.0 - t * t)
}

func TimingFunctionCircularEaseOut(t: CGFloat) -> CGFloat {
    return sqrt((2.0 - t) * t)
}

func TimingFunctionCircularEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 0.5 * (1.0 - sqrt(1.0 - 4.0 * t * t))
    } else {
        return 0.5 * sqrt(-4.0 * t * t + 8.0 * t - 3.0) + 0.5
    }
}

func TimingFunctionExponentialEaseIn(t: CGFloat) -> CGFloat {
    return (t == 0.0) ? t : pow(2.0, 10.0 * (t - 1.0))
}

func TimingFunctionExponentialEaseOut(t: CGFloat) -> CGFloat {
    return (t == 1.0) ? t : 1.0 - pow(2.0, -10.0 * t)
}

func TimingFunctionExponentialEaseInOut(t: CGFloat) -> CGFloat {
    if t == 0.0 || t == 1.0 {
        return t
    } else if t < 0.5 {
        return 0.5 * pow(2.0, 20.0 * t - 10.0)
    } else {
        return 1.0 - 0.5 * pow(2.0, -20.0 * t + 10.0)
    }
}

func TimingFunctionElasticEaseIn(t: CGFloat) -> CGFloat {
    return sin(13.0 * CGFloat.pi / 2 * t) * pow(2.0, 10.0 * (t - 1.0))
}

func TimingFunctionElasticEaseOut(t: CGFloat) -> CGFloat {
    return sin(-13.0 * CGFloat.pi / 2 * (t + 1.0)) * pow(2.0, -10.0 * t) + 1.0
}

func TimingFunctionElasticEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 0.5 * sin(13.0 * CGFloat.pi * t) * pow(2.0, 20.0 * t - 10.0)
    } else {
        return 0.5 * sin(-13.0 * CGFloat.pi * t) * pow(2.0, -20.0 * t + 10.0) + 1.0
    }
}

func TimingFunctionBackEaseIn(t: CGFloat) -> CGFloat {
    let s: CGFloat = 1.70158
    return ((s + 1.0) * t - s) * t * t
}

func TimingFunctionBackEaseOut(t: CGFloat) -> CGFloat {
    let s: CGFloat = 1.70158
    let f = 1.0 - t
    return 1.0 - ((s + 1.0) * f - s) * f * f
}

func TimingFunctionBackEaseInOut(t: CGFloat) -> CGFloat {
    let s: CGFloat = 1.70158
    if t < 0.5 {
        let f = 2.0 * t
        return 0.5 * ((s + 1.0) * f - s) * f * f
    } else {
        let f = 2.0 * (1.0 - t)
        return 1.0 - 0.5 * ((s + 1.0) * f - s) * f * f
    }
}

func TimingFunctionExtremeBackEaseIn(t: CGFloat) -> CGFloat {
    return (t * t - sin(t * CGFloat.pi)) * t
}

func TimingFunctionExtremeBackEaseOut(t: CGFloat) -> CGFloat {
    let f = 1.0 - t
    return 1.0 - (f * f - sin(f * CGFloat.pi)) * f
}

func TimingFunctionExtremeBackEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        let f = 2.0 * t
        return 0.5 * (f * f - sin(f * CGFloat.pi)) * f
    } else {
        let f = 2.0 * (1.0 - t)
        return 1.0 - 0.5 * (f * f - sin(f * CGFloat.pi)) * f
    }
}

func TimingFunctionBounceEaseIn(t: CGFloat) -> CGFloat {
    return 1.0 - TimingFunctionBounceEaseOut(t: 1.0 - t)
}

func TimingFunctionBounceEaseOut(t: CGFloat) -> CGFloat {
    if t < 1.0 / 2.75 {
        return 7.5625 * t * t
    } else if t < 2.0 / 2.75 {
        let f = t - 1.5 / 2.75
        return 7.5625 * f * f + 0.75
    } else if t < 2.5 / 2.75 {
        let f = t - 2.25 / 2.75
        return 7.5625 * f * f + 0.9375
    } else {
        let f = t - 2.625 / 2.75
        return 7.5625 * f * f + 0.984375
    }
}

func TimingFunctionBounceEaseInOut(t: CGFloat) -> CGFloat {
    if t < 0.5 {
        return 0.5 * TimingFunctionBounceEaseIn(t: t * 2.0)
    } else {
        return 0.5 * TimingFunctionBounceEaseOut(t: t * 2.0 - 1.0) + 0.5
    }
}

func TimingFunctionSmoothstep(t: CGFloat) -> CGFloat {
    return t * t * (3 - 2 * t)
}

func CreateShakeFunction(oscillations: Int) -> (CGFloat) -> CGFloat {
    return {t in -pow(2.0, -10.0 * t) * sin(t * CGFloat.pi * CGFloat(oscillations) * 2.0) + 1.0}
}
