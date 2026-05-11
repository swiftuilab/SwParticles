import Foundation

public class Collision: Behaviour {
    public var delta: Vector2D = Vector2D()
    public var emitter: Any?
    public var mass: Bool = false
    public var callback: ((Particle, Particle) -> Void)?
    public var pool: [Particle] = []
    public var newPool: [Particle] = []
    public var collisionPool: [Particle] = []
    
    public init(_ emitter: Any? = nil, _ mass: Any? = nil, _ callback: ((Particle, Particle) -> Void)? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(emitter, mass, callback)
        name = "Collision"
    }
    
    public func reset(_ emitter: Any? = nil, _ mass: Any? = nil, _ callback: ((Particle, Particle) -> Void)? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        self.emitter = Util.initValue(emitter, nil)
        self.mass = Util.initValue(mass as? Bool, true)
        self.callback = Util.initValue(callback, nil)
        
        self.collisionPool = []
        self.delta = Vector2D()
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        var newPool: [Any] = []
        if let emitter = self.emitter as? Emitter {
            let particlesArray: [Any] = emitter.particles.map { $0 as Any }
            _ = Util.sliceArray(particlesArray, index ?? 0, &newPool)
        } else {
            let poolArray: [Any] = self.pool.map { $0 as Any }
            _ = Util.sliceArray(poolArray, index ?? 0, &newPool)
        }
        let length = newPool.count
        
        var otherParticle: Particle
        var lengthSq: Double
        var overlap: Double
        var totalMass: Double
        var averageMass1: Double
        var averageMass2: Double
        var i: Int
        
        for i in 0..<length {
            guard let other = newPool[i] as? Particle else { continue }
            otherParticle = other
            
            if (otherParticle as AnyObject) !== (particle as AnyObject) {
                self.delta.copy(otherParticle.p)
                self.delta.sub(particle.p)
                
                lengthSq = self.delta.lengthSq()
                let distance = particle.radius + otherParticle.radius
                
                if lengthSq <= distance * distance {
                    overlap = distance - sqrt(lengthSq)
                    overlap += 0.5
                    
                    totalMass = particle.mass + otherParticle.mass
                    averageMass1 = self.mass ? otherParticle.mass / totalMass : 0.5
                    averageMass2 = self.mass ? particle.mass / totalMass : 0.5
                    
                    let deltaClone = self.delta.clone()
                    deltaClone.normalize()
                    deltaClone.multiplyScalar(overlap * -averageMass1)
                    particle.p.add(deltaClone)
                    
                    self.delta.normalize()
                    let vec2 = self.delta.clone()
                    vec2.multiplyScalar(overlap * averageMass2)
                    otherParticle.p.add(vec2)
                    
                    if self.callback != nil {
                        self.callback!(particle, otherParticle)
                    }
                }
            }
        }
    }
}
