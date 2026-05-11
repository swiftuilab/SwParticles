import Foundation

/// Velocity initializer (Speed in Dart)
public class Velocity: Initialize {
    private var rPan: Span?
    private var thaPan: Span?
    public var type: String = ""
    
    public init(_ rpan: Any? = nil, _ thapan: Any? = nil, _ type: String? = nil) {
        super.init()
        rPan = Span.setSpanValue(rpan)
        thaPan = Span.setSpanValue(thapan)
        self.type = Util.initValue(type, "vector")
        name = "Speed"
    }
    
    public func reset(_ rpan: Any? = nil, _ thapan: Any? = nil, _ type: String? = nil) {
        rPan = Span.setSpanValue(rpan)
        thaPan = Span.setSpanValue(thapan)
        self.type = Util.initValue(type, "vector")
    }
    
    private func normalizeVelocity(_ vr: Double) -> Double {
        return vr * SwParticles.MEASURE
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        if type == "p" || type == "P" || type == "polar" {
            let rVal = rPan?.getValue() as? Double ?? 0.0
            let thaVal = thaPan?.getValue() as? Double ?? 0.0
            let polar2d = Polar2D(normalizeVelocity(rVal), thaVal * MathUtil.PI_180)
            
            particle.v.x = polar2d.getX()
            particle.v.y = polar2d.getY()
        } else {
            let rVal = rPan?.getValue() as? Double ?? 0.0
            let thaVal = thaPan?.getValue() as? Double ?? 0.0
            particle.v.x = normalizeVelocity(rVal)
            particle.v.y = normalizeVelocity(thaVal)
        }
    }
}
