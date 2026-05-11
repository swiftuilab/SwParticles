import Foundation

public class Scale: Behaviour {
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
        self.a = Span.setSpanValue(Util.initValue(a, 1))
        self.b = Span.setSpanValue(b)
        
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let scaleAValue = a?.getValue()
        if let scaleA = scaleAValue as? Double {
            particle.data.scaleA = scaleA
        }
        particle.data.oldRadius = particle.radius
        if same {
            particle.data.scaleB = particle.data.scaleA
        } else {
            let scaleBValue = b?.getValue()
            if let scaleB = scaleBValue as? Double {
                particle.data.scaleB = scaleB
            }
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        particle.scale = particle.data.scaleB +
            (particle.data.scaleA - particle.data.scaleB) * energy
        
        if particle.scale < 0.0001 {
            particle.scale = 0
        }
        particle.radius = particle.data.oldRadius * particle.scale
    }
}
