import Foundation

public class ScaleXY: Behaviour {
    public var same: Bool = false
    private var _type: String?
    public var b: Span?
    
    public init(_ a: String = "x", _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        _type = a
        self.b = Span.setSpanValue(b)
        name = "ScaleXY"
    }
    
    public func reset(_ a: String = "x", _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        _type = a
        self.b = Span.setSpanValue(b)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let val = b?.getValue()
        if let value = val as? Double {
            if _type == "x" {
                particle.data.x = value
            } else if _type == "y" {
                particle.data.y = value
            }
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        if _type == "x" {
            // In SwiftUI, we handle scale differently
            // particle.body.scale.x = particle.data.x
        } else if _type == "y" {
            // particle.body.scale.y = particle.data.y
        }
    }
}
