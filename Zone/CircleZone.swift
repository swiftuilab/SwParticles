import Foundation

/// Circle zone for particle positioning
public class CircleZone: Zone {
    public var x: Double = 0.0
    public var y: Double = 0.0
    public var radius: Double = 0.0
    public var angle: Double = 0.0
    public var randomRadius: Double = 0.0
    public var center: Vector2D?
    
    public init(_ x: Double, _ y: Double, _ radius: Double) {
        super.init()
        self.x = x
        self.y = y
        self.radius = radius
        self.angle = 0
        self.center = Vector2D(x, y)
    }
    
    public override func getPosition() -> Vector2D {
        angle = MathUtil.PIx2 * MathUtil.random()
        randomRadius = MathUtil.random() * radius
        vector.x = self.x + randomRadius * cos(angle)
        vector.y = self.y + randomRadius * sin(angle)
        
        return vector
    }
    
    public func setCenter(_ x: Double, _ y: Double) {
        center?.x = x
        center?.y = y
    }
    
    public override func crossing(_ particle: Particle) {
        guard let center = center else { return }
        let d = particle.p.distanceTo(center)
        
        if crossType == "dead" {
            if d - particle.radius > radius {
                particle.dead = true
            }
        } else if crossType == "bound" {
            if d + particle.radius >= radius {
                self.getSymmetric(particle)
            }
        } else if crossType == "cross" {
            if alert {
                print("Sorry, CircleZone does not support cross method!")
                alert = false
            }
        }
    }
    
    public func getSymmetric(_ particle: Particle) {
        guard let center = center else { return }
        let tha2 = particle.v.getGradient() ?? 0.0
        let tha1 = getGradient(particle)
        let tha = 2 * (tha1 - tha2)
        let oldx = particle.v.x
        let oldy = particle.v.y
        
        particle.v.x = oldx * cos(tha) - oldy * sin(tha)
        particle.v.y = oldx * sin(tha) + oldy * cos(tha)
    }
    
    public func getGradient(_ particle: Particle) -> Double {
        guard let center = center else { return 0.0 }
        return -MathUtil.PI_2 + atan2(particle.p.y - center.y, particle.p.x - center.x)
    }
}
