import Foundation

/// Rectangular zone for particle positioning
public class RectZone: Zone {
    public var x: Double = 0.0
    public var y: Double = 0.0
    public var width: Double = 0.0
    public var height: Double = 0.0
    
    public init(_ x: Double, _ y: Double, _ width: Double, _ height: Double) {
        super.init()
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public func reset(_ x: Double, _ y: Double, _ width: Double, _ height: Double) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }
    
    public override func getPosition() -> Vector2D {
        vector.x = x + MathUtil.random() * width
        vector.y = y + MathUtil.random() * height
        return vector
    }
    
    public override func crossing(_ particle: Particle) {
        // particle dead zone
        if crossType == "dead" {
            if particle.p.x + particle.radius < x {
                particle.dead = true
            } else if particle.p.x - particle.radius > x + width {
                particle.dead = true
            }
            
            if particle.p.y + particle.radius < y {
                particle.dead = true
            } else if particle.p.y - particle.radius > y + height {
                particle.dead = true
            }
        }
        
        // particle bound zone
        else if crossType == "bound" {
            if particle.p.x - particle.radius < x {
                particle.p.x = x + particle.radius
                particle.v.x *= -1
            } else if particle.p.x + particle.radius > x + width {
                particle.p.x = x + width - particle.radius
                particle.v.x *= -1
            }
            
            if particle.p.y - particle.radius < y {
                particle.p.y = y + particle.radius
                particle.v.y *= -1
            } else if particle.p.y + particle.radius > y + height {
                particle.p.y = y + height - particle.radius
                particle.v.y *= -1
            }
        }
        
        // particle cross zone
        else if crossType == "cross" {
            if particle.p.x + particle.radius < x && particle.v.x <= 0 {
                particle.p.x = x + width + particle.radius
            } else if particle.p.x - particle.radius > x + width && particle.v.x >= 0 {
                particle.p.x = x - particle.radius
            }
            
            if particle.p.y + particle.radius < y && particle.v.y <= 0 {
                particle.p.y = y + height + particle.radius
            } else if particle.p.y - particle.radius > y + height && particle.v.y >= 0 {
                particle.p.y = y - particle.radius
            }
        }
    }
}
