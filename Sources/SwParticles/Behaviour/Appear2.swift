import Foundation

public class Appear2: Behaviour {
    public var same: Bool = false
    public var begin: Double = 0
    public var end: Double = 0
    
    public init(_ a: Double = 1.0/4.0, _ b: Double = 3.0/4.0, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        begin = a
        end = b
        name = "Appear2"
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        particle.data.oldRadius = particle.radius
        particle.scale = 0
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        let age = particle.age / particle.life
        if age <= begin {
            particle.scale = age * (1.0 / begin)
        } else if age >= end {
            particle.scale = age / (1 - end) - 1.0 / (1 - end)
            //particle.alpha = age / (1 - end) - 1 / (1 - end);
        }
        
        particle.radius = particle.data.oldRadius * particle.scale
    }
}
