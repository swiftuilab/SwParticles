import Foundation

/// Graphic initializer
public class Graphic: Initialize {
    private var _shape: String = "circle"
    private var _count: Double = 5
    
    public init(_ shape: String = "circle", _ count: Double = 5) {
        super.init()
        _shape = shape
        _count = count
        name = "Graphic"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        particle.data.shape = _shape
        
        if _shape == "star" {
            particle.data.count = Int(_count)
            particle.renderType = "star"
        } else if _shape == "polygon" {
            particle.data.count = Int(_count)
            particle.renderType = "polygon"
        } else if _shape == "rect2" {
            particle.data.rect2 = _count
            particle.renderType = "rect"
        } else {
            particle.renderType = "circle"
        }
    }
}

