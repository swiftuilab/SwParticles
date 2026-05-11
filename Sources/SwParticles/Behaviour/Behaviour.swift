import Foundation

/// Base class for particle behaviours
public class Behaviour {
    private static var _index: Int = 0
    
    public var life: Double = 0.0
    public var easing: ((Double) -> Double)?
    public var age: Double = 0.0
    public var energy: Double = 0.0
    public var dead: Bool = false
    public var parents: [Any] = []
    
    public var id: String = ""
    public var name: String = ""
    
    public init(_ life: Any? = nil, _ easing: String? = nil) {
        self.life = Util.initValue(life as? Double, Double.infinity)
        self.easing = Ease.getEasingFunc(easing ?? "easeLinear")
        
        self.age = 0
        self.energy = 1
        self.dead = false
        self.id = "behaviour_\(Behaviour._index)"
        Behaviour._index += 1
        name = "Behaviour"
    }
    
    public func reset(_ life: Any? = nil, _ easing: String? = nil) {
        self.life = Util.initValue(life as? Double, Double.infinity)
        self.easing = Ease.getEasingFunc(easing ?? "easeLinear")
    }
    
    public func normalizeForce(_ force: Vector2D) -> Vector2D {
        return force.multiplyScalar(SwParticles.MEASURE)
    }
    
    public func normalizeValue(_ value: Double) -> Double {
        return value * SwParticles.MEASURE
    }
    
    public func initialize(_ particle: PBody) {
        // Override in subclasses
    }
    
    public func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        calculate(particle, time, index)
    }
    
    public func calculate(_ particle: PBody, _ time: Double, _ index: Int?) {
        self.age += time
        
        if self.age >= self.life || self.dead {
            self.energy = 0
            self.dead = true
            self.destroy()
        } else {
            let scale = self.easing!(particle.age / particle.life)
            self.energy = max(1 - scale, 0)
        }
    }
    
    public func destroy() {
        var i = self.parents.count - 1
        while i >= 0 {
            if let emitter = self.parents[i] as? Emitter {
                emitter.removeBehaviour(self)
            }
            i -= 1
        }
        
        self.parents.removeAll()
    }
}
