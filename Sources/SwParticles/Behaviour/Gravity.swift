import Foundation

public class Gravity: Force {
    public init(_ g: Double = 0, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(0, g, life, easing)
        name = "Gravity"
    }
    
    public func reset(_ fx: Any? = nil, _ fy: Any? = nil, _ life: Any? = nil, _ easing: String? = nil, _ d: Any? = nil) {
        super.reset(0, fy, life, easing)
    }
}
