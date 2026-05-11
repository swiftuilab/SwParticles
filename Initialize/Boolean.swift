import Foundation

/// Boolean initializer
public class Boolean: Initialize {
    private var _prob: Double = 0.5
    
    public init(_ prob: Double) {
        super.init()
        _prob = prob
        name = "Boolean"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        particle.data.open = MathUtil.random() > _prob
    }
}

