import Foundation

/// 2D Vector class
public class Vector2D {
    public var x: Double = 0
    public var y: Double = 0
    
    public init(_ x: Double = 0, _ y: Double = 0) {
        self.x = x
        self.y = y
    }
    
    @discardableResult
    public func set(_ x: Double, _ y: Double) -> Vector2D {
        self.x = x
        self.y = y
        return self
    }
    
    @discardableResult
    public func setX(_ x: Double) -> Vector2D {
        self.x = x
        return self
    }
    
    @discardableResult
    public func setY(_ y: Double) -> Vector2D {
        self.y = y
        return self
    }
    
    public func getGradient() -> Double? {
        if self.x != 0 {
            return atan2(self.y, self.x)
        } else if self.y > 0 {
            return MathUtil.PI_2
        } else if self.y < 0 {
            return -MathUtil.PI_2
        }
        return nil
    }
    
    public func isNaN() -> Bool {
        if x.isNaN || y.isNaN { return true }
        return false
    }
    
    @discardableResult
    public func copy(_ v: Vector2D) -> Vector2D {
        self.x = v.x
        self.y = v.y
        
        return self
    }
    
    @discardableResult
    public func add(_ v: Vector2D? = nil, _ w: Vector2D? = nil) -> Vector2D {
        if w != nil {
            return self.addVectors(v!, w!)
        }
        
        if let v = v {
            self.x += v.x
            self.y += v.y
        }
        
        return self
    }
    
    @discardableResult
    public func addXY(_ a: Double, _ b: Double) -> Vector2D {
        self.x += a
        self.y += b
        
        return self
    }
    
    @discardableResult
    public func addVectors(_ a: Vector2D, _ b: Vector2D) -> Vector2D {
        self.x = a.x + b.x
        self.y = a.y + b.y
        
        return self
    }
    
    @discardableResult
    public func sub(_ v: Vector2D? = nil, _ w: Vector2D? = nil) -> Vector2D {
        if w != nil {
            return self.subVectors(v!, w!)
        }
        
        if let v = v {
            self.x -= v.x
            self.y -= v.y
        }
        
        return self
    }
    
    @discardableResult
    public func subVectors(_ a: Vector2D, _ b: Vector2D) -> Vector2D {
        self.x = a.x - b.x
        self.y = a.y - b.y
        
        return self
    }
    
    @discardableResult
    public func divideScalar(_ s: Double) -> Vector2D {
        if s != 0 {
            self.x /= s
            self.y /= s
        } else {
            self.set(0.0, 0.0)
        }
        
        return self
    }
    
    @discardableResult
    public func multiplyScalar(_ s: Double) -> Vector2D {
        self.x *= s
        self.y *= s
        
        return self
    }
    
    @discardableResult
    public func negate() -> Vector2D {
        return self.multiplyScalar(-1)
    }
    
    public func dot(_ v: Vector2D) -> Double {
        return self.x * v.x + self.y * v.y
    }
    
    public func lengthSq() -> Double {
        return self.x * self.x + self.y * self.y
    }
    
    public func length() -> Double {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    @discardableResult
    public func normalize() -> Vector2D {
        return self.divideScalar(self.length())
    }
    
    public func distanceTo(_ v: Vector2D) -> Double {
        return sqrt(self.distanceToSquared(v))
    }
    
    @discardableResult
    public func rotate(_ tha: Double) -> Vector2D {
        let x = self.x
        let y = self.y
        
        self.x = x * cos(tha) + y * sin(tha)
        self.y = -x * sin(tha) + y * cos(tha)
        
        return self
    }
    
    public func distanceToSquared(_ v: Vector2D) -> Double {
        let dx = self.x - v.x
        let dy = self.y - v.y
        
        return dx * dx + dy * dy
    }
    
    @discardableResult
    public func lerp(_ v: Vector2D, _ alpha: Double) -> Vector2D {
        self.x += (v.x - self.x) * alpha
        self.y += (v.y - self.y) * alpha
        
        return self
    }
    
    public func equals(_ v: Vector2D) -> Bool {
        return v.x == self.x && v.y == self.y
    }
    
    @discardableResult
    public func clear() -> Vector2D {
        x = 0.0
        y = 0.0
        return self
    }
    
    public func clone() -> Vector2D {
        return Vector2D(x, y)
    }
}

extension Vector2D: CustomStringConvertible {
    public var description: String {
        return "x:\(x) y:\(y)"
    }
}
