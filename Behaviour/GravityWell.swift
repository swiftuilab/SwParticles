import Foundation

public class GravityWell: Behaviour {
    public var distanceVec: Vector2D = Vector2D()
    public var centerPoint: Vector2D = Vector2D()
    public var force: Double = 0.0
    
    public init(_ centerPoint: Any? = nil, _ force: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(centerPoint, force, life, easing)
        name = "GravityWell"
    }
    
    public func reset(_ centerPoint: Any? = nil, _ force: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        distanceVec = Vector2D()
        self.centerPoint = Util.initValue(centerPoint as? Vector2D, Vector2D())
        let forceValue = Util.initValue(force as? Double, 100.0)
        self.force = normalizeValue(forceValue)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        // Empty implementation
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        distanceVec.set(centerPoint.x - particle.p.x, centerPoint.y - particle.p.y)
        let distanceSq = distanceVec.lengthSq()
        
        if distanceSq != 0 {
            let distance = distanceVec.length()
            let factor = (force * time) / (distanceSq * distance)
            particle.v.x += factor * distanceVec.x
            particle.v.y += factor * distanceVec.y
        }
    }
}
