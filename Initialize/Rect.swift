import Foundation

public class Rect: Initialize {
    public var width: Span?
    public var height: Span?
    
    public init(_ width: Any? = nil, _ height: Any? = nil) {
        super.init()
        self.width = Span.setSpanValue(width)
        self.height = Span.setSpanValue(height)
        name = "Rect"
    }
    
    public func reset(_ width: Any? = nil, _ height: Any? = nil) {
        self.width = Span.setSpanValue(width)
        self.height = Span.setSpanValue(height)
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        
        let widthValue = width?.getValue()
        let heightValue = height?.getValue()
        
        if let widthNum = widthValue as? Double {
            particle.data.rectWidth = widthNum
        }
        if let heightNum = heightValue as? Double {
            particle.data.rectHeight = heightNum
        }
        
        particle.renderType = "rect"
    }
}

