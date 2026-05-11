import Foundation

/// Particle emitter
public class Emitter: Particle, EventDispatching {
    public var particles: [Particle] = []
    //public var behaviours: [Behaviour] = []
    public var initializes: [Initialize] = []
    
    public var totalTime: Any = -1
    public var emitTime: Double = 0.0
    public var emitSpeed: Double = 0.0
    public var damping: Double = 0.006
    
    public var bindEmitter: Bool = false
    public var bindEvent: Bool = false
    public var stoped: Bool = false
    public var rate: Rate?
    public var didCreateParticle: ((Particle) -> Void)?
    private var eventDispatcher = EventDispatcher()
    
    public required override init() {
        super.init()
        self.bindEmitter = true
        self.rate = Rate(1, 0.1)
        name = "Emitter"
        self.id = Puid.id(self.name)
    }
    
    /// Start emitting particles
    public func emit(_ totalTime: Any? = nil, _ life: Any? = false) {
        self.stoped = false
        self.emitTime = 0
        self.totalTime = Util.initValue(totalTime, Double.infinity)
        
        if let life = life as? Bool, life {
            self.life = (totalTime as? String == "once") ? 1 : (self.totalTime as? Double ?? Double.infinity)
        } else if let life = life as? String, (life == "life" || life == "destroy") {
            self.life = (totalTime as? String == "once") ? 1 : (self.totalTime as? Double ?? Double.infinity)
        } else if let lifeNum = life as? Double {
            self.life = lifeNum
        }
    
        self.rate?.initFunc()
    }
    
    /// Stop emitting
    public func stop() {
        self.totalTime = -1
        self.emitTime = 0
        self.stoped = true
    }
    
    /// Pre-emit particles
    public func preEmit(_ time: Double) {
        let oldStoped = self.stoped
        let oldEmitTime = self.emitTime
        let oldTotalTime = self.totalTime
        
        self.stoped = false
        self.emitTime = 0
        self.totalTime = time
        self.rate?.initFunc()
        
        let step: Double = 0.0167
        var remainingTime = time
        while remainingTime > step {
            remainingTime -= step
            self.update(step, nil)
        }
        
        self.stoped = oldStoped
        self.emitTime = oldEmitTime + max(remainingTime, 0)
        self.totalTime = oldTotalTime
    }
    
    /// Remove all particles
    public func removeAllParticles() {
        var i = self.particles.count - 1
        while i >= 0 {
            self.particles[i].dead = true
            i -= 1
        }
    }
    
    /// Add self initialize
    public func addSelfInitialize(_ initialize: [String: Any]) {
        if initialize.keys.contains("initFunc") {
            // Handle initFunc if needed - this would need to be a callable function
            // In Swift, we can't easily check for callable functions in dictionaries
        } else {
            //this.initAll();
        }
    }
    
    /// Add initialize
    public func addInitialize(_ initialize: Initialize) {
        self.initializes.append(initialize)
    }
    
    /// Remove initialize
    public func removeInitialize(_ initializer: Initialize) {
        if let index = self.initializes.firstIndex(where: { $0 === initializer }) {
            self.initializes.remove(at: index)
        }
    }
    
    /// Remove all initializers
    public func removeAllInitializers() {
        self.initializes.removeAll()
    }
    
    /// Add behaviour
    public override func addBehaviour(_ behaviour: Behaviour) {
        self.behaviours.append(behaviour)
        behaviour.parents.append(self)
    }
    
    /// Remove behaviour
    public override func removeBehaviour(_ behaviour: Behaviour) {
        if let index = self.behaviours.firstIndex(where: { $0 === behaviour }) {
            self.behaviours.remove(at: index)
            
            if let parentIndex = behaviour.parents.firstIndex(where: { ($0 as? AnyObject) === (self as AnyObject) }) {
                behaviour.parents.remove(at: parentIndex)
            }
        }
    }
    
    /// Remove all behaviours
    public override func removeAllBehaviours() {
        self.behaviours.removeAll()
    }
    
    /// Update emitter
    public override func update(_ time: Double, _ index: Int? = nil) {
        self.age += time
        if self.age >= self.life || self.dead {
            self.destroy()
        }
        
        self.emitting(time)
        self.integrate(time)
    }
    
    /// Integrate particles
    private func integrate(_ time: Double) {
        guard let parent = self.parent as? SwParticles else { return }
        
        let damping = 1 - self.damping
        parent.integrator.calculate(self, time, damping)
        
        let length = self.particles.count
        var i: Int
        
        for i in stride(from: length - 1, through: 0, by: -1) {
            let particle = self.particles[i]
            
            // particle update
            particle.update(time, i)
            parent.integrator.calculate(particle, time, damping)
            self.dispatch("PARTICLE_UPDATE", particle)
            
            // check dead
            if particle.dead {
                self.dispatch("PARTICLE_DEAD", particle)
                if let poolId = particle.id {
                    parent.pool.expire("Particle", particle)
                }
                self.particles.remove(at: i)
            }
        }
    }
    
    /// Dispatch event
    private func dispatch(_ event: String, _ target: Any?) {
        if let parent = self.parent as? SwParticles {
            parent.dispatchEvent(event, target)
        }
        if self.bindEvent {
            self.dispatchEvent(event, target)
        }
    }
    
    /// Emit particles
    private func emitting(_ time: Double) {
        if let totalTimeStr = self.totalTime as? String, totalTimeStr == "none" {
            return
        }
  
        if let totalTimeStr = self.totalTime as? String, totalTimeStr == "once" {
            var i: Int
            let length = self.rate?.getValue(99999) ?? 0
            
            if length > 0 {
                self.emitSpeed = Double(length)
            }
            for i in 0..<length {
                _ = self.createParticle()
            }
            self.totalTime = "none"
        } else {
            self.emitTime += time
            
            if let totalTimeNum = self.totalTime as? Double, self.emitTime < totalTimeNum {
                let length = self.rate?.getValue(time) ?? 0
                var i: Int
                
                if length > 0 {
                    self.emitSpeed = Double(length)
                }
                for i in 0..<length {
                    _ = self.createParticle()
                }
            }
        }
    }
    
    /// Create a particle
    @discardableResult
    public func createParticle(_ initialize: Any? = nil, _ behaviour: Any? = nil) -> Particle {
        guard let parent = self.parent as? SwParticles else {
            return Particle()
        }
        
        let particle = parent.pool.get("Particle", nil, nil) as? Particle ?? Particle()
        self.setupParticle(particle, initialize, behaviour)
        self.dispatch("PARTICLE_CREATED", particle)
        return particle
    }
    
    /// Setup particle
    public func setupParticle(_ particle: Particle, _ initialize: Any? = nil, _ behaviour: Any? = nil) {
        var initializes = self.initializes
        var behaviours = self.behaviours
        
        if let initialize = initialize {
            if let initArray = initialize as? [Initialize] {
                initializes = initArray
            } else if let initSingle = initialize as? Initialize {
                initializes = [initSingle]
            }
        }
        
        if let behaviour = behaviour {
            if let behArray = behaviour as? [Behaviour] {
                behaviours = behArray
            } else if let behSingle = behaviour as? Behaviour {
                behaviours = [behSingle]
            }
        }
        
        particle.reset()
        particle.p.x = -100
        particle.old?.p.x = -100
        InitializeUtil.initialize(self, particle, initializes)
        particle.addBehaviours(behaviours)
        particle.parent = self
        particles.append(particle)
        
        if let didCreateParticle = self.didCreateParticle {
            didCreateParticle(particle)
        }
    }
    
    /// Get initialize by name
    public func getInitialize(_ name: String) -> Initialize? {
        for i in 0..<initializes.count {
            if initializes[i].name == name {
                return initializes[i]
            }
        }
        return nil
    }
    
    /// Get behaviour by name
    public func getBehaviour(_ name: String) -> Behaviour? {
        for i in 0..<behaviours.count {
            if behaviours[i].name == name {
                return behaviours[i]
            }
        }
        return nil
    }
    
    /// Remove emitter
    public func remove() {
        stop()
        deadAllParticles()
    }
    
    /// Dead all particles
    public func deadAllParticles() {
        for i in 0..<particles.count {
            particles[i].dead = true
            particles[i].reset()
            if let parent = self.parent as? SwParticles {
                if let poolId = particles[i].id {
                    parent.pool.expire("Particle", particles[i])
                }
            }
        }
        
        particles.removeAll()
    }
    
    /// Destroy emitter
    public override func destroy() {
        remove()
        removeAllInitializers()
        removeAllBehaviours()
        if let parent = self.parent as? SwParticles {
            parent.removeEmitter(self)
        }
        parent = nil
        rate = nil
        super.destroy()
    }
    
    // MARK: - EventDispatching
    
    public func dispatchEvent(_ type: String, _ args: Any? = nil) {
        eventDispatcher.dispatchEvent(type, args)
    }
    
    @discardableResult
    public func addEventListener(_ type: String, _ listener: @escaping EventListener) -> EventListener {
        return eventDispatcher.addEventListener(type, listener)
    }
    
    public func removeEventListener(_ type: String, _ listener: @escaping EventListener) {
        eventDispatcher.removeEventListener(type, listener)
    }
    
    public func removeAllEventListeners(_ type: String? = nil) {
        eventDispatcher.removeAllEventListeners(type)
    }
    
    public func hasEventListener(_ type: String) -> Bool {
        return eventDispatcher.hasEventListener(type)
    }
}
