import Foundation

/// Base class for zones
public class Zone {
    public var vector: Vector2D = Vector2D(0.0, 0.0)
    public var random: Double = 0.0
    public var crossType: String = ""
    public var alert: Bool = false
    
    public init() {
        crossType = "dead"
        alert = true
    }
    
    public func getPosition() -> Vector2D {
        // Override in subclasses
        return vector
    }
    
    public func crossing(_ particle: Particle) {
        // Override in subclasses
    }
    
    public func destroy() {
        //this.vector = null;
    }
}
