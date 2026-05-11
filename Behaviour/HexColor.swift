import Foundation
import SwiftUI
import UIKit

public class HexColor: Behaviour {
    public var a: Span?
    public var b: Span?
    public var renderType: String = "auto"
    private var _isRandom: Bool = false
    
    public init(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        reset(a, b, life, easing)
        name = "HexColor"
    }
    
    @discardableResult
    public func renderOnce() -> HexColor {
        renderType = "once"
        return self
    }
    
    public func reset(_ a: Any? = nil, _ b: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        var processedA = a
        
        if let intA = a as? Int {
            processedA = PColor.fromHex(intA)
        } else if var strA = a as? String {
            if strA == "random" {
                _isRandom = true
            } else {
                strA = strA.replacingOccurrences(of: "#", with: "")
                if let num = Int(strA, radix: 16) {
                    processedA = PColor.fromHex(num)
                }
            }
        } else if let listA = a as? [Any] {
            if let firstItem = listA.first as? Int {
                var arr: [PColor] = []
                for i in 0..<listA.count {
                    if let intItem = listA[i] as? Int {
                        arr.append(PColor.fromHex(intItem))
                    }
                }
                processedA = arr
            } else if let firstItem = listA.first as? String {
                var arr: [PColor] = []
                for i in 0..<listA.count {
                    if var strItem = listA[i] as? String {
                        strItem = strItem.replacingOccurrences(of: "#", with: "")
                        if let num = Int(strItem, radix: 16) {
                            arr.append(PColor.fromHex(num))
                        }
                    }
                }
                processedA = arr
            }
        }
        
        var processedB = b
        if let intB = b as? Int {
            processedB = PColor.fromHex(intB)
        }
        
        self.a = ArraySpan.createArraySpan(processedA)
        self.b = ArraySpan.createArraySpan(processedB)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        if renderType == "once" {
            particle.renderColorOnce = true
        }
        
        if _isRandom {
            let randomColor = MathUtil.randomColor()
            particle.color.copyFromColor(Color(red: Double(randomColor.red)/255.0, green: Double(randomColor.green)/255.0, blue: Double(randomColor.blue)/255.0))
            particle.data.colorA = PColor.fromPColor(particle.color)
        } else {
            let colorValue = self.a?.getValue()
            if let color = colorValue as? PColor {
                particle.color.copy(color)
            } else if let color = colorValue as? Color {
                particle.color.copyFromColor(color)
            }
            particle.data.colorA = PColor.fromPColor(particle.color)
        }
        if self.b != nil {
            let colorBValue = self.b?.getValue()
            if let colorB = colorBValue as? PColor {
                particle.data.colorB = PColor.fromPColor(colorB)
            } else if let colorB = colorBValue as? Color {
                particle.data.colorB = PColor.fromColor(colorB)
            }
        }
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        if self.b != nil {
            calculate(particle, time, index)
            
            if let colorA = particle.data.colorA, let colorB = particle.data.colorB {
                let red = Double(colorB.red) + (Double(colorA.red) - Double(colorB.red)) * energy
                let green = Double(colorB.green) + (Double(colorA.green) - Double(colorB.green)) * energy
                let blue = Double(colorB.blue) + (Double(colorA.blue) - Double(colorB.blue)) * energy
                
                particle.color.red = Int(red.rounded())
                particle.color.green = Int(green.rounded())
                particle.color.blue = Int(blue.rounded())
            }
        } else {
            if let colorA = particle.data.colorA {
                particle.color.red = colorA.red
                particle.color.green = colorA.green
                particle.color.blue = colorA.blue
            }
        }
    }
}
