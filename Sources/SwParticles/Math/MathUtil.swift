import Foundation
import SwiftUI

/// Mathematical utility functions
public struct MathUtil {
    public static let PI: Double = 3.14159267
    public static let PI_2: Double = PI / 2
    public static let PIx2: Double = PI * 2
    public static let PI_180: Double = PI / 180
    public static let N180_PI: Double = 180 / PI
    public static let Infinity: Double = -999
    // Random number generation handled by Double.random
    
    public static func isInfinity(_ num: Double) -> Bool {
        return num == MathUtil.Infinity || num == Double.infinity
    }
    
    public static func getRWidth(_ initScale: Double, _ width: Double, _ appWidth: Double) -> Double {
        var scale: Double = 1
        scale = initScale / (width / appWidth)
        return scale
    }
    
    public static func randomAToB(_ min: Double, _ max: Double, isInt: Bool = false) -> Any {
        let val = Double.random(in: 0...1) * (max - min) + min
        return isInt ? floor(val) : val
    }
    
    public static func randomFloating(_ center: Double, _ f: Double, isInt: Bool = false) -> Any {
        return MathUtil.randomAToB(center - f, center + f, isInt: isInt)
    }
    
    public static func randomColor() -> PColor {
        let value = Int.random(in: 0..<0x1000000)
        let r = (value >> 16) & 0xff
        let g = (value >> 8) & 0xff
        let b = value & 0xff
        return PColor(r, g, b, 255)
    }
    
    public static func random(_ val: Double = 1.0) -> Double {
        return Double.random(in: 0...1) * val
    }
    
    public static func mod(_ a: Double, _ b: Double) -> Double {
        return a.truncatingRemainder(dividingBy: b)
    }
    
    public static func randomZone(_ display: Any) {
        // Empty implementation
    }
    
    public static func floor(_ num: Double, k: Int = 4) -> Double {
        let digits = pow(10.0, Double(k))
        return Foundation.floor(num * digits) / digits
    }
    
    public static func degreeTransform(_ a: Double) -> Double {
        return (a * PI) / 180
    }
    
    public static func max(_ a: Double, _ b: Double) -> Double {
        return a >= b ? a : b
    }
    
    public static func min(_ a: Double, _ b: Double) -> Double {
        return a <= b ? a : b
    }
    
    public static func abs(_ a: Double) -> Double {
        return a >= 0 ? a : -a
    }
    
    public static func easing(_ particle: Particle, _ x: Double, _ y: Double, _ ease: Double) {
        particle.p.x += (x - particle.p.x) * ease
        particle.p.y += (y - particle.p.y) * ease
    }
    
    public static func easingPositionByData(_ particle: Particle, _ ease: Double) {
        particle.p.x += (particle.data.x - particle.p.x) * ease
        particle.p.y += (particle.data.y - particle.p.y) * ease
    }
    
    public static func easingAlphaByData(_ particle: Particle, _ ease: Double) {
        particle.alpha += (particle.data.alpha - particle.alpha) * ease
    }
    
    public static func easingScaleByData(_ particle: Particle, _ ease: Double) {
        particle.scale += (particle.data.scale - particle.scale) * ease
    }
    
    public static func easingAllByData(_ particle: Particle, _ ease: Double) {
        easingPositionByData(particle, ease)
        easingScaleByData(particle, ease)
        easingAlphaByData(particle, ease)
    }
}
