import Foundation

/// Image zone for particle positioning
public class ImageZone: Zone {
    // Empty implementation as imagezone.dart is empty
    public override init() {
        super.init()
    }
    
    public override func getPosition() -> Vector2D {
        return vector
    }
    
    public override func crossing(_ particle: Particle) {
        // Empty implementation
    }
}
