import Foundation

/// Base class for particle initializers
public class Initialize {
    public var name: String = ""
    
    public init() {
    }
    
    public func initFunc(_ emitter: PBody, _ particle: PBody?) {
        if particle != nil {
            initialize(particle!)
        } else {
            initialize(emitter)
        }
    }
    
    // sub class initFunc
    public func initialize(_ target: PBody) {
        // Override in subclasses
    }
}
