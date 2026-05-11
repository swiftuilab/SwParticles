import Foundation

public class Repulsion: Attraction {
    public override init(_ targetPosition: Any? = nil, _ force: Any? = nil, _ radius: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(targetPosition, force, radius, life, easing)
        self.force *= -1
        name = "Repulsion"
    }
    
    public override func reset(_ targetPosition: Any? = nil, _ force: Any? = nil, _ radius: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.reset(targetPosition, force, radius, life, easing)
        self.force *= -1
    }
}
