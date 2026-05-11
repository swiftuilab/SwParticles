import Foundation

/// Base class for particle body (physics properties)
public class PBody {
    public var p: Vector2D = Vector2D(0, 0)
    public var v: Vector2D = Vector2D(0, 0)
    public var a: Vector2D = Vector2D(0, 0)
    
    public var body: Any? = nil
    public var renderType: String = "circle"
    public var renderColorOnce: Bool = false
    public var color: PColor = PColor(255, 255, 255, 255)
    public var data: Data = Data()
    public var life: Double = 0
    public var age: Double = 0
    public var energy: Double = 1.0
    public var mass: Double = 1.0
    public var radius: Double = 1.0
    public var alpha: Double = 1.0
    public var scale: Double = 1.0
    public var scaleVec: Vector2D = Vector2D(1, 1)
    public var rotation: Double = 0.0
    
    public init() {
    }
    
    public func reset() {
        p.set(0.0, 0.0)
        v.set(0.0, 0.0)
        a.set(0.0, 0.0)
        renderType = "circle"
    }
    
    public func getDirection() -> Double {
        return 0
    }
    
    public func destroy() {
        // v = null;
        // a = null;
        // p = null;
    }
}

