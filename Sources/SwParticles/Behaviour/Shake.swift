import Foundation

public class Shake: Behaviour {
    private var _min: Double = 0
    private var _max: Double = 0
    private var _speed: Double = 0
    public var ease: Double = 0.05
    private var _type: String = "cos"
    
    public init(_ min: Double, _ max: Double, _ speed: Double) {
        super.init()
        _min = min
        _max = max
        _speed = speed
    }
    
    @discardableResult
    public func setEase(_ ease: Double) -> Shake {
        self.ease = ease
        return self
    }
    
    @discardableResult
    public func setType(_ type: String) -> Shake {
        _type = type
        return self
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let radiusValue = MathUtil.randomAToB(_min, _max)
        let angleValue = MathUtil.randomAToB(0, 2 * 3.1415)
        let speedValue = MathUtil.randomAToB(-_speed, _speed)
        if let r = radiusValue as? Double {
            particle.data.radius = r
        }
        if let a = angleValue as? Double {
            particle.data.angle = a
        }
        if let s = speedValue as? Double {
            particle.data.speed = s
        }
        particle.data.value = 0
        particle.data.x = particle.p.x
        particle.data.y = particle.p.y
    }
    
    public func setXY(_ particle: Particle, _ x: Double, _ y: Double) {
        particle.data.x = x
        particle.data.y = y
    }
    
    public func setParticlePosition(_ particle: Particle) {
        particle.data.x = particle.p.x
        particle.data.y = particle.p.y
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        let radius = particle.data.radius
        let speed = particle.data.speed
        let x0 = particle.data.x
        let y0 = particle.data.y
        
        if _type == "circling" || _type == "circle" {
            particle.v.clear()
            particle.data.angle += speed
            let x = x0 + radius * cos(particle.data.angle)
            let y = y0 + radius * sin(particle.data.angle)
            particle.p.x += (x - particle.p.x) * ease
            particle.p.y += (y - particle.p.y) * ease
        } else {
            particle.data.value += speed
            let currentRadius = radius * cos(particle.data.value)
            let x = x0 + currentRadius * cos(particle.data.angle)
            let y = y0 + currentRadius * sin(particle.data.angle)
            particle.p.x += (x - particle.p.x) * ease
            particle.p.y += (y - particle.p.y) * ease
        }
    }
    
    public override func destroy() {
        super.destroy()
    }
}
