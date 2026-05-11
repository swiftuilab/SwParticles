import Foundation

/// Polar coordinate representation
public class Polar2D {
    public var r: Double = 0
    public var tha: Double = 0
    
    public init(_ r: Double = 0, _ tha: Double = 0) {
        self.r = abs(r)
        self.tha = tha
    }
    
    @discardableResult
    public func set(_ r: Double, _ tha: Double) -> Polar2D {
        self.r = r
        self.tha = tha
        return self
    }
    
    @discardableResult
    public func setR(_ r: Double) -> Polar2D {
        self.r = r
        return self
    }
    
    @discardableResult
    public func setTha(_ tha: Double) -> Polar2D {
        self.tha = tha
        return self
    }
    
    @discardableResult
    public func copy(_ p: Polar2D) -> Polar2D {
        self.r = p.r
        self.tha = p.tha
        return self
    }
    
    public func toVector() -> Vector2D {
        return Vector2D(self.getX(), self.getY())
    }
    
    public func getX() -> Double {
        return self.r * sin(self.tha)
    }
    
    public func getY() -> Double {
        return -self.r * cos(self.tha)
    }
    
    @discardableResult
    public func normalize() -> Polar2D {
        self.r = 1
        return self
    }
    
    public func equals(_ v: Polar2D) -> Bool {
        return v.r == self.r && v.tha == self.tha
    }
    
    @discardableResult
    public func clear() -> Polar2D {
        self.r = 0.0
        self.tha = 0.0
        return self
    }
    
    public func clone() -> Polar2D {
        return Polar2D(self.r, self.tha)
    }
}
