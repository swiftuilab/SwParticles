import Foundation

/// Constants for the particle system
public struct Consts {
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
}

