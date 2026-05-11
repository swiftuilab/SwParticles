import Foundation

/// Life initializer for particle lifetime
public class Life: Initialize {
    private var lifePan: Span?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ c: Bool? = nil) {
        super.init()
        lifePan = Span.setSpanValue(a, b, c)
        name = "Life"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        if let lifePan = lifePan {
            let aDouble = lifePan.a.toDouble()
            if aDouble == Double.infinity {
                particle.life = Double.infinity
            } else {
                let lifeValue = lifePan.getValue()
                if let lifeNum = lifeValue as? Double {
                    particle.life = lifeNum
                }
            }
        } else {
            let lifeValue = lifePan?.getValue()
            if let lifeNum = lifeValue as? Double {
                particle.life = lifeNum
            }
        }
    }
}
