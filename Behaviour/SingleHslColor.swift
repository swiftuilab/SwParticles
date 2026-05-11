import Foundation

public class SingleHslColor: HexColor {
    private var _colors: [PColor] = []
    
    public init(_ _h: Int = 100, _ _s: Int = 50, _ _l: Int = 50) {
        super.init()
        _colors.append(PColor.fromHsl(_h, _s, _l))
    }
    
    @discardableResult
    public func fromListColor(_ _hs: [Int], _ _s: Int, _ _l: Int) -> SingleHslColor {
        for i in 0..<_hs.count {
            _colors.append(PColor.fromHsl(_hs[i], _s, _l))
        }
        return self
    }
    
    @discardableResult
    public override func renderOnce() -> SingleHslColor {
        renderType = "once"
        return self
    }
    
    public func add(_ _h: Int) {
        for i in 0..<_colors.count {
            _colors[i].h += _h
            _colors[i].toRgb()
        }
    }
    
    public func getColor() -> PColor? {
        return Util.getRandFromArray(_colors) as? PColor
    }
    
    public func setRandomColor() {
        if _colors.isEmpty { return }
        let color = _colors[0]
        var h = Int(MathUtil.random(360))
        h = h % 360
        color.setHsl(h, color.s, color.l)
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        if let color = Util.getRandFromArray(_colors) as? PColor {
            particle.color.copy(color)
        }
        if renderType == "once" {
            particle.renderColorOnce = true
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        calculate(particle, time, index)
    }
    
    public override func destroy() {
        _colors.removeAll()
        super.destroy()
    }
}
