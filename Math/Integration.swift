import Foundation

/// Integration methods for physics simulation
public class Integration {
    public var type: String = ""
    
    public init(type: String) {
        self.type = type
    }
    
    /// Calculate integration step
    public func calculate(_ particles: Any, _ time: Double, _ damping: Double?) {
        self.eulerIntegrate(particles, time, damping)
    }
    
    /// Euler integration method
    // https://rosettacode.org/wiki/Euler_method
    private func eulerIntegrate(_ particle: Any, _ time: Double, _ damping: Double?) {
        guard let particle = particle as? Particle else { return }
        
        if particle.dead { return }
        
        if !particle.sleep {
            particle.old?.p.copy(particle.p)
            particle.old?.v.copy(particle.v)
            
            particle.a.multiplyScalar(1 / particle.mass)
            particle.v.add(particle.a.multiplyScalar(time))
            particle.p.add(particle.old!.v.multiplyScalar(time))
            
            if damping != nil {
                particle.v.multiplyScalar(damping!)
            }
            
            particle.a.clear()
        }
    }
}
