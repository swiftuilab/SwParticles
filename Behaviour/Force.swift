import Foundation

public class Force: Behaviour {
    public var force: Vector2D = Vector2D()
    
    public init(_ fx: Double = 0, _ fy: Double = 0, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        self.force = normalizeForce(Vector2D(fx, fy))
        name = "Force"
    }
    
    public func reset(_ fx: Any? = nil, _ fy: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        let fxValue = fx as? Double ?? 0.0
        let fyValue = fy as? Double ?? 0.0
        self.force = normalizeForce(Vector2D(fxValue, fyValue))
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        calculate(particle, time, index)
        particle.a.add(self.force)
    }
}
