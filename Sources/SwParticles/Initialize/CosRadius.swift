import Foundation

private var _cosRadiusIndex: Int = 0

/// CosRadius initializer
public class CosRadius: Initialize {
    private var _min: Double = 0
    private var _max: Double = 0
    private var _rate: Double = 0
    private var _type: String = "count"
    
    public init(_ min: Double, _ max: Double, _ rate: Double = 1, _ type: String = "count") {
        super.init()
        _max = max
        _min = min
        _rate = rate
        _type = type
        name = "CosRadius"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        _cosRadiusIndex += 1
        let tha = Double(_cosRadiusIndex) * (1.0 / 3.14159) * _rate
        particle.radius = _min + (_max - _min) * (cos(tha) + 1) * 0.5
        particle.data.oldRadius = particle.radius
    }
}

