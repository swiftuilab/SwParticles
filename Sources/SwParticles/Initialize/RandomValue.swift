import Foundation

/// RandomValue initializer
public class RandomValue: Initialize {
    public var count: Int = 0
    
    public init(_ count: Int) {
        super.init()
        self.count = count
        name = "RandomValue"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        particle.data.count = count
    }
}

