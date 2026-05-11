import Foundation

/// Position initializer
public class Position: Initialize {
    public var zone: Zone?
    
    public init(_ zone: Any? = nil) {
        super.init()
        self.zone = Util.initValue(zone as? Zone, PointZone(0.0, 0.0))
        name = "Position"
    }
    
    public func reset(_ zone: Any? = nil) {
        self.zone = Util.initValue(zone as? Zone, PointZone(0.0, 0.0))
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        guard let zone = zone else { return }
        _ = zone.getPosition()
        particle.p.x = zone.vector.x
        particle.p.y = zone.vector.y
    }
}
