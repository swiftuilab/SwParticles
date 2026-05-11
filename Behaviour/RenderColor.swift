import Foundation

public class RenderColor: Behaviour {
    public var type: String = "once"
    
    public init(_ type: String) {
        super.init()
        self.type = type
        name = "RenderColor"
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        if type == "once" {
            particle.renderColorOnce = true
        } else {
            particle.renderColorOnce = false
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        calculate(particle, time, index)
    }
}
