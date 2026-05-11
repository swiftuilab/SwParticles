import Foundation

public class Rotate: Behaviour {
    public var same: Bool = false
    public var a: Span?
    public var b: Span?
    public var style: String = ""
    public var way: String = "to"
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ style: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(a, b, style, life, easing)
        name = "Rotate"
    }
    
    @discardableResult
    public func setWay(_ way: String) -> Rotate {
        self.way = way
        return self
    }
    
    @discardableResult
    public func add() -> Rotate {
        return setWay("add")
    }
    
    public func setRotation(_ r: Double) {
        if var bSpan = b as? Span {
            // Note: Span doesn't expose a/b directly, so this is a limitation
            // In Dart: b?.a = r; b?.b = r;
        }
    }
    
    public func reset(_ a: Any? = nil, _ b: Any? = nil, _ style: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        same = b == nil ? true : false
        
        self.a = Span.setSpanValue(Util.initValue(a, "Velocity"))
        self.b = Span.setSpanValue(Util.initValue(b, 0))
        self.style = Util.initValue(style as? String, "to")
        
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let rotationAValue = a?.getValue()
        if let rotationA = rotationAValue as? Double {
            particle.rotation = rotationA
            particle.data.rotationA = rotationA
        }
        
        if !same {
            let rotationBValue = b?.getValue()
            if let rotationB = rotationBValue as? Double {
                particle.data.rotationB = rotationB
            }
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        if way == "direction" || way == "DIRECTION" {
            particle.rotation = particle.getDirection()
        } else if !same {
            if way == "to" || way == "TO" || way == "_" {
                particle.rotation = particle.data.rotationB +
                    (particle.data.rotationA - particle.data.rotationB) * energy
            } else {
                particle.rotation += particle.data.rotationB
            }
        }
    }
}
