import Foundation

public class Attraction: Behaviour {
    public var targetPosition: Vector2D = Vector2D()
    public var attractionForce: Vector2D = Vector2D()
    public var radius: Double = 0.0
    public var force: Double = 0.0
    public var radiusSq: Double = 0.0
    public var lengthSq: Double = 0.0
    
    public init(_ targetPosition: Any? = nil, _ force: Any? = nil, _ radius: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(targetPosition, force, radius, life, easing)
        name = "Attraction"
    }
    
    public func reset(_ targetPosition: Any? = nil, _ force: Any? = nil, _ radius: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        self.targetPosition = Util.initValue(targetPosition as? Vector2D, Vector2D())
        if let radiusValue = radius as? Double {
            self.radius = radiusValue
        } else {
            self.radius = Util.initValue(radius as? Double, 1000.0)
        }
        if let forceValue = force as? Double {
            self.force = self.normalizeValue(forceValue)
        } else {
            self.force = Util.initValue(self.normalizeValue(force as? Double ?? 100), 100)
        }
        
        self.radiusSq = self.radius * self.radius
        self.attractionForce = Vector2D()
        self.lengthSq = 0
        
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        self.attractionForce.copy(self.targetPosition)
        self.attractionForce.sub(particle.p)
        self.lengthSq = self.attractionForce.lengthSq()
        
        if self.lengthSq > 0.00004 && self.lengthSq < self.radiusSq {
            self.attractionForce.normalize()
            self.attractionForce.multiplyScalar(1.0 - self.lengthSq / self.radiusSq)
            self.attractionForce.multiplyScalar(self.force)
            
            particle.a.add(self.attractionForce)
        }
    }
}
