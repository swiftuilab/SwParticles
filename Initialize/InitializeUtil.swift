import Foundation

/// Utility for initializing particles
public struct InitializeUtil {
    public static func initialize(_ emitter: Emitter, _ particle: Particle?, _ initializes: [Any]) {
        let length = initializes.count
        var i: Int
        
        for i in 0..<length {
            if initializes[i] is Initialize {
                (initializes[i] as! Initialize).initFunc(emitter, particle)
            } else {
                InitializeUtil.initFunc(emitter, particle, initializes[i] as! [String: Any])
            }
        }
        
        InitializeUtil.bindEmitter(emitter, particle)
    }
    
    // initFunc
    public static func initFunc(_ emitter: Emitter, _ particle: Particle?, _ initialize: [String: Any]) {
        guard let particle = particle else { return }
        PropUtil.setVectorVal(particle, initialize)
    }
    
    public static func bindEmitter(_ emitter: Emitter, _ particle: Particle?) {
        guard let particle = particle else { return }
        if emitter.bindEmitter {
            particle.p.add(emitter.p)
            particle.v.add(emitter.v)
            particle.a.add(emitter.a)
            particle.v.rotate(MathUtil.degreeTransform(emitter.rotation))
        }
    }
}
