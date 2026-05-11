import Foundation

public class Scale2: Behaviour {
    public var same: Bool = false
    public var a: Span?
    public var b: Span?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(a, b, life, easing)
        name = "Scale"
    }
    
    public func reset(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        self.same = b == nil ? true : false
        self.a = Span.setSpanValue(a)
        self.b = Span.setSpanValue(b)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        particle.data.oldRadius = particle.radius
        particle.scale = 0
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        if particle.energy >= 2.0 / 3.0 {
            particle.scale = (1 - particle.energy) * 3
        } else if particle.energy <= 1.0 / 3.0 {
            particle.scale = particle.energy * 3
        }
        
        particle.radius = particle.data.oldRadius * particle.scale
    }
}
