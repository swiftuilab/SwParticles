import Foundation

/// Count initializer
public class Count: Initialize {
    public var count: Int = 0
    
    public init(_ count: Int) {
        super.init()
        self.count = count
        name = "Count"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        particle.data.count = count
    }
}

