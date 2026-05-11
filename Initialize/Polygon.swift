import Foundation

/// Polygon initializer
public class Polygon: Initialize {
    private var _list: [Int] = []
    private var _type: String = "count"
    
    public init(_ list: [Int], _ type: String = "count") {
        super.init()
        _list = list
        _type = type
        name = "Polygon"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        let count = Util.getRandFromArray(_list) as? Int ?? 3
        if count < 3 {
            particle.data.shape = "circle"
        } else if count == 4 {
            particle.data.shape = "rect"
        } else if count == 5 {
            particle.data.shape = "star"
        }
    }
}

