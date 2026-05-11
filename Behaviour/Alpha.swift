import Foundation

public class Alpha: Behaviour {
    public var same: Bool = false
    public var a: Span?
    public var b: Span?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(a, b, life, easing)
        name = "Alpha"
    }
    
    public func reset(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        same = b == nil ? true : false
        self.a = Span.setSpanValue(Util.initValue(a, 1))
        self.b = Span.setSpanValue(b)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let alphaAValue = a?.getValue()
        if let alphaA = alphaAValue as? Double {
            particle.data.alphaA = alphaA
        }
        
        if same {
            particle.data.alphaB = particle.data.alphaA
        } else {
            let alphaBValue = b?.getValue()
            if let alphaB = alphaBValue as? Double {
                particle.data.alphaB = alphaB
            }
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        particle.alpha = particle.data.alphaB +
            (particle.data.alphaA - particle.data.alphaB) * energy
        
        if particle.alpha < 0.001 {
            particle.alpha = 0
        }
    }
}
