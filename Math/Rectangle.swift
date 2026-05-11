import Foundation

/// Rectangle representation
public class MathRectangle {
    public var x: Double = 0.0
    public var y: Double = 0.0
    public var width: Double = 0.0
    public var height: Double = 0.0
    public var bottom: Double = 0.0
    public var right: Double = 0.0
    
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        self.x = x
        self.y = y
        
        self.width = w
        self.height = h
        
        self.bottom = self.y + self.height
        self.right = self.x + self.width
    }
    
    public func contains(_ x: Double, _ y: Double) -> Bool {
        if x <= self.right && x >= self.x && y <= self.bottom && y >= self.y {
            return true
        } else {
            return false
        }
    }
}
