import Foundation

/// Point zone for particle positioning
public class PointZone: Zone {
    public var x: Double = 0.0
    public var y: Double = 0.0
    
    public init(_ x: Double, _ y: Double) {
        super.init()
        self.x = x
        self.y = y
    }
    
    public override func getPosition() -> Vector2D {
        vector.x = x
        vector.y = y
        
        return vector
    }
    
    public override func crossing(_ particle: Particle) {
        if alert {
            print("Sorry, PointZone does not support crossing method!")
            alert = false
        }
    }
}
