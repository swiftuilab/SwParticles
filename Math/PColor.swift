import Foundation
import SwiftUI
import UIKit

/// PColor - Extended color class with HSL support
public class PColor {
    private var _value: Int = 0
    public var alpha: Int = 255
    public var red: Int = 0
    public var green: Int = 0
    public var blue: Int = 0
    public var h: Int = 0
    public var s: Int = 90
    public var l: Int = 70
    
    public init(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 255) {
        value = (((a & 0xff) << 24) |
                ((r & 0xff) << 16) |
                ((g & 0xff) << 8) |
                ((b & 0xff) << 0)) &
            0xFFFFFFFF
        setRGBA()
    }
    
    ////////////////////////////////////////////////////////////
    ///
    /// RGB color transform
    ///
    ////////////////////////////////////////////////////////////
    
    public var value: Int {
        get {
            _value = (((alpha & 0xff) << 24) |
                    ((red & 0xff) << 16) |
                    ((green & 0xff) << 8) |
                    ((blue & 0xff) << 0)) &
                0xFFFFFFFF
            
            return _value
        }
        set {
            _value = newValue
        }
    }
    
    public func getAlpha() -> Int {
        return (0xff000000 & _value) >> 24
    }
    
    public func getOpacity() -> Double {
        return Double(alpha) / 0xFF
    }
    
    public func getRed() -> Int {
        return (0x00ff0000 & _value) >> 16
    }
    
    public func getGreen() -> Int {
        return (0x0000ff00 & _value) >> 8
    }
    
    public func getBlue() -> Int {
        return (0x000000ff & _value) >> 0
    }
    
    public func setRGBA(_ r: Int? = nil, _ g: Int? = nil, _ b: Int? = nil, _ a: Int? = nil) {
        alpha = a ?? getAlpha()
        red = r ?? getRed()
        green = g ?? getGreen()
        blue = b ?? getBlue()
    }
    
    public func setAlpha(_ a: Int) {
        alpha = a
    }
    
    public func copy(_ color: PColor) {
        red = color.red
        green = color.green
        blue = color.blue
        alpha = color.alpha
        h = color.h
        s = color.s
        l = color.l
    }
    
    ////////////////////////////////////////////////////////////
    ///
    /// value and color
    ///
    ////////////////////////////////////////////////////////////
    
    public func reset(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 1) {
        // Empty implementation as in Dart
    }
    
    public func copyFromColor(_ color: Color) {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        setRGBA(Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
    
    public static func fromColor(_ color: Color) -> PColor {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return PColor(Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }
    
    public static func fromPColor(_ color: PColor) -> PColor {
        return PColor(color.red, color.green, color.blue, color.alpha)
    }
    
    public static func fromValue(_ value: Int) -> PColor {
        let r = (0x00ff0000 & value) >> 16
        let g = (0x0000ff00 & value) >> 8
        let b = (0x000000ff & value) >> 0
        let a = (0xff000000 & value) >> 24
        
        return PColor(r, g, b, a)
    }
    
    ////////////////////////////////////////////////////////////
    ///
    /// HSL Color Transform
    ///
    ////////////////////////////////////////////////////////////
    
    public func clone() -> PColor {
        let color = PColor(red, green, blue, alpha)
        return color
    }
    
    public func setHex(_ hex: Int) {
        red = (hex >> 16) & 0xff
        green = (hex >> 8) & 0xff
        blue = (hex >> 0) & 0xff
    }
    
    public func toHex() -> Int {
        return (0xff & red << 16) | (0xff & green << 8) | (0xff & blue)
    }
    
    public func setHsl(_ _h: Int? = nil, _ _s: Int? = nil, _ _l: Int? = nil) {
        if _h == nil {
            h = h % 360
            PColor.hslToRgb(self, h, s, l)
        } else {
            PColor.hslToRgb(self, _h!, _s!, _l!)
        }
    }
    
    public func toRgb() {
        setHsl()
    }
    
    public func toHsl() {
        PColor.rgbToHsl(self)
    }
    
    ////////////////////////////////////////////////////////////
    ///
    /// static method
    ///
    ////////////////////////////////////////////////////////////
    
    public static func fromHex(_ hex: Int) -> PColor {
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = (hex >> 0) & 0xff
        return PColor(red, green, blue)
    }
    
    public static func fromHsl(_ h: Int, _ s: Int, _ l: Int, _ alpha: Int = 255) -> PColor {
        let color = PColor(255, 255, 255, 255)
        hslToRgb(color, h, s, l)
        color.alpha = alpha
        return color
    }
    
    public static func hslToRgb(_ color: PColor, _ h: Int, _ s: Int, _ l: Int) {
        color.h = h
        color.s = s
        color.l = l
        
        let _h = Double(h) / 360
        let _s = Double(s) / 100
        let _l = Double(l) / 100
        
        var r: Double, g: Double, b: Double
        if s == 0 {
            r = _l
            g = _l
            b = _l // achromatic
        } else {
            let q = _l < 0.5 ? _l * (1 + _s) : _l + _s - _l * _s
            let p = 2 * _l - q
            let dis = 0.3333333
            
            r = _hueToRgbVal(p, q, _h + dis)
            g = _hueToRgbVal(p, q, _h)
            b = _hueToRgbVal(p, q, _h - dis)
        }
        
        color.red = Int(r * 255)
        color.green = Int(g * 255)
        color.blue = Int(b * 255)
    }
    
    private static func _hueToRgbVal(_ p: Double, _ q: Double, _ t: Double) -> Double {
        var t = t
        if t < 0 { t += 1 }
        if t > 1 { t -= 1 }
        if t < 0.16666666 { return p + (q - p) * 6 * t }
        if t < 0.5 { return q }
        if t < 0.66666666 { return p + (q - p) * (0.66666666 - t) * 6 }
        return p
    }
    
    public static func rgbToHsl(_ color: PColor) {
        let r = Double(color.red) / 255.0
        let g = Double(color.green) / 255.0
        let b = Double(color.blue) / 255.0
        let maxc = MathUtil.max(MathUtil.max(r, g), b)
        let minc = MathUtil.min(MathUtil.min(r, g), b)
        
        var _h: Double = 0
        var _s: Double = 0
        var _l: Double = 0
        let value = (maxc + minc) / 2.0
        _h = value
        _s = value
        _l = value
        
        if maxc == minc {
            _h = 0
            _s = 0 // achromatic
        } else {
            let d = maxc - minc
            _s = (Double(color.l) > 0.5) ? d / (2.0 - maxc - minc) : d / (maxc + minc)
            
            if maxc == r {
                _h = (g - b) / d + (g < b ? 6.0 : 0)
            } else if maxc == g {
                _h = (b - r) / d + 2.0
            } else if maxc == b {
                _h = (r - g) / d + 4.0
            }
            
            _h /= 6.0
        }
        
        color.h = Int(_h * 360.0)
        color.s = Int(_s * 100.0)
        color.l = Int(_l * 100.0)
    }
}

extension PColor: CustomStringConvertible {
    public var description: String {
        return "r:\(red) g:\(green) b:\(blue) a:\(alpha) - h:\(h) s:\(s) l:\(l)"
    }
}

