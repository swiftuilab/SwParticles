import Foundation

public class Appear: Behaviour {
    private var _type: String = "scale"
    private var _time: Double = 1
    
    public init(_ type: String, _ time: Double = 0.5, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        name = "Appear"
        _time = time
        _type = type
    }
    
    public override func initialize(_ particle: PBody) {
        // Empty implementation
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        let age = max(particle.age - particle.data.delay, 0)
        if age > _time { return }
        
        if _type == "scale" || _type == "zoom" {
            particle.scale = age / _time
            //particle.alpha = particle.age / _time;
        }
    }
}
