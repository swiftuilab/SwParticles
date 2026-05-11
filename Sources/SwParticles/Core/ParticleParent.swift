import Foundation

public protocol ParticleParent: AnyObject {
    var pool: Pool { get }
    var integrator: Integration { get }
    
    func dispatchEvent(_ type: String, _ args: Any?)
    func removeEmitter(_ emitter: Emitter)
}

