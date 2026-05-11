import Foundation

/// Mass initializer
public class Mass: Initialize {
    private var massPan: Span?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ c: Bool? = nil) {
        super.init()
        massPan = Span.setSpanValue(a, b, c)
        name = "Mass"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        let massValue = massPan?.getValue()
        if let massNum = massValue as? Double {
            particle.mass = massNum
        }
    }
}
