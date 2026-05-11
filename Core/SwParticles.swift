import Foundation

/// Main particle system engine (formerly Proton, renamed to SwParticles)
public class SwParticles: EventDispatching {
    public static var useRealTime: Bool = true
    public static var fixLongIntervalByApp: Bool = true
    
    // measure 1:100
    public static let MEASURE: Double = 100
    public static let EULER = "euler"
    public static let RK2 = "runge-kutta2"
    
    // event name
    public static let PARTICLE_CREATED = "PARTICLE_CREATED"
    public static let PARTICLE_UPDATE = "PARTICLE_UPDATE"
    public static let PARTICLE_SLEEP = "PARTICLE_SLEEP"
    public static let PARTICLE_DEAD = "PARTICLE_DEAD"
    
    public static let EMITTER_ADDED = "EMITTER_ADDED"
    public static let EMITTER_REMOVED = "EMITTER_REMOVED"
    
    public static let PROTON_UPDATE = "PROTON_UPDATE"
    public static let DEFAULT_INTERVAL: Double = 0.0167
    
    public var time: Double = 0.0
    public var now: Double = 0.0
    public var then: Double = 0.0
    public var elapsed: Double = 0.0
    public var destoryPool: Bool = true
    
    public var pool: Pool
    public var integrationType: String = ""
    public var integrator: Integration
    
    private var _fps: Any = "auto"
    private var _intervalTime: Double = 0.0
    
    public var emitters: [Emitter] = []
    public var renderer: Any?
    
    private var eventDispatcher = EventDispatcher()
    
    public init(_ npool: Pool? = nil) {
        time = 0
        now = 0
        then = 0
        elapsed = 0
        integrator = Integration(type: SwParticles.EULER)
        _fps = "auto"
        _intervalTime = SwParticles.DEFAULT_INTERVAL
        pool = Pool(80)
        _initPool(npool)
    }
    
    private func _initPool(_ npool: Pool?) {
        if let npool = npool {
            pool = npool
        }
        pool.create = { param1, param2 in
            return Particle()
        }
    }
    
    public var fps: Any {
        get {
            return _fps
        }
        set {
            _fps = newValue
            if let fpsStr = newValue as? String, fpsStr == "auto" {
                _intervalTime = SwParticles.DEFAULT_INTERVAL
            } else if let fpsNum = newValue as? Double {
                _intervalTime = MathUtil.floor(1.0 / fpsNum, k: 7)
            }
        }
    }
    
    public func setRenderer(_ render: Any?) {
        self.renderer = render
    }
    
    public func addEmitter(_ emitter: Emitter) {
        emitters.append(emitter)
        emitter.parent = self
        dispatchEvent(SwParticles.EMITTER_ADDED, emitter)
    }
    
    public func removeEmitter(_ emitter: Emitter) {
        if let index = emitters.firstIndex(where: { $0 === emitter }) {
            emitters.remove(at: index)
            emitter.parent = nil
            dispatchEvent(SwParticles.EMITTER_REMOVED, emitter)
        }
    }
    
    public func update(_ millisecond: Int = 0) {
        // 'auto' is the default browser refresh rate, the vast majority is 60fps
        if let fpsStr = _fps as? String, fpsStr == "auto" {
            dispatchEvent(SwParticles.PROTON_UPDATE, nil)
            
            if SwParticles.useRealTime {
                if millisecond <= 0 {
                    if then == 0 { then = DateUtil.now() }
                    now = DateUtil.now()
                    elapsed = (now - then) * 0.001
                } else {
                    elapsed = Double(millisecond) * 0.001
                }
                
                if elapsed > 0 {
                    emittersUpdate(elapsed)
                }
                then = now
            } else {
                emittersUpdate(SwParticles.DEFAULT_INTERVAL)
            }
        }
        // If the fps frame rate is set
        else {
            if then == 0 { then = DateUtil.now() }
            now = DateUtil.now()
            elapsed = (now - then) * 0.001
            if elapsed > _intervalTime {
                dispatchEvent(SwParticles.PROTON_UPDATE, nil)
                emittersUpdate(_intervalTime)
                // https://stackoverflow.com/questions/19764018/controlling-fps-with-requestanimationframe
                then = now - (elapsed.truncatingRemainder(dividingBy: _intervalTime)) * 1000.0
            }
        }
    }
    
    private func emittersUpdate(_ elapsed: Double) {
        var i = emitters.count - 1
        while i >= 0 {
            emitters[i].update(elapsed, nil)
            i -= 1
        }
    }
    
    public func getCount() -> Int {
        var total = 0
        var i = emitters.count - 1
        while i >= 0 {
            total += emitters[i].particles.count
            i -= 1
        }
        return total
    }
    
    public func getAllParticles() -> [Particle] {
        var particles: [Particle] = []
        var i = emitters.count - 1
        while i >= 0 {
            particles.append(contentsOf: emitters[i].particles)
            i -= 1
        }
        return particles
    }
    
    public func destroyAllEmitters() {
        let len = emitters.count
        for i in stride(from: len - 1, through: 0, by: -1) {
            emitters[i].destroy()
        }
        emitters.removeAll()
    }
    
    public func destroy() {
        time = 0
        then = 0
        destroyAllEmitters()
        if destoryPool {
            pool.destroy()
        }
        renderer = nil
        var allParticles = getAllParticles();
        allParticles.removeAll()
    }
    
    public func getEmitterParticles() -> String {
        var str = ""
        for i in 0..<emitters.count {
            str += "[em\(i)]-"
            str += String(emitters[i].particles.count)
            if i < emitters.count - 1 {
                str += " | "
            }
        }
        return str
    }
    
    // MARK: - EventDispatching
    
    public func dispatchEvent(_ type: String, _ args: Any?) {
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

extension SwParticles: CustomStringConvertible {
    public var description: String {
        return "[PS] \(pool)"
    }
}
