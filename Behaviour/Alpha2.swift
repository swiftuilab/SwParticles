import Foundation

public class Alpha2: Behaviour {
    public var same: Bool = false
    public var begin: Double = 0
    public var end: Double = 0
    private var _alpha: Span?
    
    public init(_ a: Double = 1.0/4.0, _ b: Double = 3.0/4.0, _ alpha: Span? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        begin = a
        end = b
        _alpha = alpha
        name = "Alpha2"
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        let alphaValue = _alpha?.getValue()
        if let alpha = alphaValue as? Double {
            particle.data.alphaA = alpha
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        let va = particle.data.alphaA
        let age = particle.age / particle.life
        if age <= begin {
            particle.alpha = va * age * (1.0 / begin)
        } else if age >= end {
            particle.alpha = va * (age / (end - 1) - 1.0 / (end - 1))
        }
    }
}
