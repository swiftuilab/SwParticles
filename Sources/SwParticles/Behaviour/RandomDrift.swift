import Foundation

public class RandomDrift: Behaviour {
    public var panFoce: Vector2D = Vector2D()
    public var time: Double = 0.0
    public var delay: Double = 0.0
    
    public init(_ driftX: Double? = nil, _ driftY: Double? = nil, _ delay: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(driftX, driftY, delay)
        self.time = 0
        name = "RandomDrift"
    }
    
    public func reset(_ driftX: Any? = nil, _ driftY: Any? = nil, _ delay: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        let driftXValue = driftX as? Double ?? 0.0
        let driftYValue = driftY as? Double ?? 0.0
        panFoce = Vector2D(driftXValue, driftYValue)
        panFoce = normalizeForce(panFoce)
        self.delay = delay as? Double ?? 0.0
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        particle.data.time = 0.0
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        particle.data.time += time
        
        if particle.data.time >= self.delay {
            let randomX = MathUtil.randomAToB(-panFoce.x, panFoce.x)
            let randomY = MathUtil.randomAToB(-panFoce.y, panFoce.y)
            if let x = randomX as? Double, let y = randomY as? Double {
                particle.a.addXY(x, y)
            }
            particle.data.time = 0.0
        }
    }
}
