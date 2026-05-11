import Foundation

/// Mark initializer
public class Mark: Initialize {
    public var mark: String = ""
    
    public init(_ mark: String) {
        super.init()
        self.mark = mark
        name = "Mark"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        particle.data.mark = mark
    }
}

