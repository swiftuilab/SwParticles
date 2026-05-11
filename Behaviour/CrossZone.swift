import Foundation

public class CrossZone: Behaviour {
    public var zone: Zone?
    
    public init(_ zone: Any? = nil, _ crossType: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(zone, crossType, life, easing)
        name = "CrossZone"
    }
    
    public func reset(_ zone: Any? = nil, _ crossType: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        self.zone = zone as? Zone
        self.zone?.crossType = Util.initValue(crossType as? String, "dead")
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        self.zone?.crossing(particle)
    }
}
