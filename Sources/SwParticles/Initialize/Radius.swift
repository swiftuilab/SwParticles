import Foundation

/// Radius initializer
public class Radius: Initialize {
    public var radius: Span?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ c: Bool? = nil) {
        super.init()
        radius = Span.setSpanValue(a, b, c)
        name = "Radius"
    }
    
    public func reset(_ a: Any? = nil, _ b: Any? = nil, _ c: Bool? = nil) {
        radius = Span.setSpanValue(a, b, c)
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        let radiusValue = radius?.getValue()
        
        if let radiusNum = radiusValue as? Double {
            particle.radius = radiusNum
            particle.data.oldRadius = particle.radius
        }
    }
}
