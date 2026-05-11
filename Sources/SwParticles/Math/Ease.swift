import Foundation

/// Easing functions for animations
public struct Ease {
    public static func easeLinear(_ value: Double) -> Double {
        return value
    }
    
    public static func easeInQuad(_ value: Double) -> Double {
        return pow(value, 2)
    }
    
    public static func easeOutQuad(_ value: Double) -> Double {
        return -(pow(value - 1, 2) - 1)
    }
    
    public static func easeInOutQuad(_ value: Double) -> Double {
        var v = value / 0.5
        if v < 1 {
            return 0.5 * pow(v, 2)
        }
        v -= 2
        return -0.5 * (v * v - 2)
    }
    
    public static func easeInCubic(_ value: Double) -> Double {
        return pow(value, 3)
    }
    
    public static func easeOutCubic(_ value: Double) -> Double {
        return pow(value - 1, 3) + 1
    }
    
    public static func easeInOutCubic(_ value: Double) -> Double {
        var v = value / 0.5
        if v < 1 {
            return 0.5 * pow(v, 3)
        }
        return 0.5 * (pow(v - 2, 3) + 2)
    }
    
    public static func easeInQuart(_ value: Double) -> Double {
        return pow(value, 4)
    }
    
    public static func easeOutQuart(_ value: Double) -> Double {
        return -(pow(value - 1, 4) - 1)
    }
    
    public static func easeInOutQuart(_ value: Double) -> Double {
        var v = value / 0.5
        if v < 1 {
            return 0.5 * pow(v, 4)
        }
        v -= 2
        return -0.5 * (v * pow(v, 3) - 2)
    }
    
    public static func easeInSine(_ value: Double) -> Double {
        return -cos(value * MathUtil.PI_2) + 1
    }
    
    public static func easeOutSine(_ value: Double) -> Double {
        return sin(value * MathUtil.PI_2)
    }
    
    public static func easeInOutSine(_ value: Double) -> Double {
        return -0.5 * (cos(MathUtil.PI * value) - 1)
    }
    
    public static func easeInExpo(_ value: Double) -> Double {
        return value == 0 ? 0 : pow(2, 10 * (value - 1))
    }
    
    public static func easeOutExpo(_ value: Double) -> Double {
        return value == 1 ? 1 : -pow(2, -10 * value) + 1
    }
    
    public static func easeInOutExpo(_ value: Double) -> Double {
        if value == 0 { return 0 }
        if value == 1 { return 1 }
        
        var v = value / 0.5
        if v < 1 {
            return 0.5 * pow(2, 10 * (v - 1))
        }
        v -= 1
        return 0.5 * (-pow(2, -10 * v) + 2)
    }
    
    public static func easeInCirc(_ value: Double) -> Double {
        return -(sqrt(1 - value * value) - 1)
    }
    
    public static func easeOutCirc(_ value: Double) -> Double {
        return sqrt(1 - pow(value - 1, 2))
    }
    
    public static func easeInOutCirc(_ value: Double) -> Double {
        var v = value / 0.5
        if v < 1 {
            return -0.5 * (sqrt(1 - v * v) - 1)
        }
        v -= 2
        return 0.5 * (sqrt(1 - v * v) + 1)
    }
    
    public static func easeInBack(_ value: Double) -> Double {
        let s: Double = 1.70158
        return value * value * ((s + 1) * value - s)
    }
    
    public static func easeOutBack(_ value: Double) -> Double {
        let s: Double = 1.70158
        var v = value - 1
        return v * value * ((s + 1) * v + s) + 1
    }
    
    public static func easeInOutBack(_ value: Double) -> Double {
        var s: Double = 1.70158
        var v = value / 0.5
        if v < 1 {
            s *= 1.525
            return 0.5 * (v * v * ((s + 1) * v - s))
        }
        v -= 2
        s *= 1.525
        return 0.5 * (v * v * ((s + 1) * v + s) + 2)
    }
    
    /// Get easing function by name or return the function itself
    public static func getEasingFunc(_ val: Any) -> (Double) -> Double {
        if let fn = val as? (Double) -> Double {
            return fn
        } else {
            if let name = val as? String {
                switch name {
                case "easeInQuad": return easeInQuad
                case "easeOutQuad": return easeOutQuad
                case "easeInOutQuad": return easeInOutQuad
                case "easeInCubic": return easeInCubic
                case "easeOutCubic": return easeOutCubic
                case "easeInOutCubic": return easeInOutCubic
                case "easeInQuart": return easeInQuart
                case "easeOutQuart": return easeOutQuart
                case "easeInOutQuart": return easeInOutQuart
                case "easeInSine": return easeInSine
                case "easeOutSine": return easeOutSine
                case "easeInOutSine": return easeInOutSine
                case "easeInExpo": return easeInExpo
                case "easeOutExpo": return easeOutExpo
                case "easeInOutExpo": return easeInOutExpo
                case "easeInCirc": return easeInCirc
                case "easeOutCirc": return easeOutCirc
                case "easeInOutCirc": return easeInOutCirc
                case "easeInBack": return easeInBack
                case "easeOutBack": return easeOutBack
                case "easeInOutBack": return easeInOutBack
                default: return easeLinear
                }
            }
            return easeLinear
        }
    }
}
