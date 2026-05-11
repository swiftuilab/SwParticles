import Foundation

public class HslColor: HexColor {
    private var _addSpeed: Int = 0
    public var h: Int = 0
    public var s: Int = 0
    public var l: Int = 0
    private var _isRandom: Bool = false
    
    public init(_ _h: Any, _ _s: Int, _ _l: Int) {
        super.init()
        if let hStr = _h as? String {
            _isRandom = true
        } else if let hInt = _h as? Int {
            h = hInt
        }
        
        s = _s
        l = _l
        _addSpeed = 0
        renderType = "auto"
        name = "HslColor"
    }
    
    @discardableResult
    public override func renderOnce() -> HslColor {
        renderType = "once"
        return self
    }
    
    public func add(_ speed: Int) {
        _addSpeed = speed
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        if _isRandom {
            h = Int(MathUtil.random(360.0))
        }
        h = h % 360
        particle.color.setHsl(h, s, l)
        
        if renderType == "once" {
            particle.renderColorOnce = true
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        if _addSpeed != 0 {
            particle.color.h += _addSpeed
            particle.color.toRgb()
        }
    }
}
