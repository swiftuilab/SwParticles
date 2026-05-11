import Foundation

/// Property utility functions
public struct PropUtil {
    public static func hasProp(_ target: Any?, _ key: String) -> Bool {
        if target == nil { return false }
        if let dict = target as? [String: Any] {
            return dict[key] != nil
        }
        return false
    }
    
    public static func setProp(_ target: inout [String: Any], _ props: [String: Any]) -> [String: Any] {
        for prop in props.keys {
            if target.keys.contains(prop) {
                target[prop] = Span.getSpanValue(props[prop] ?? 0)
            }
        }
        
        return target
    }
    
    public static func setVectorVal(_ particle: Particle, _ conf: [String: Any]?) {
        if conf == nil { return }
        
        if PropUtil.hasProp(conf, "x") {
            if let x = conf!["x"] as? Double {
                particle.p.x = x
            }
        }
        if PropUtil.hasProp(conf, "y") {
            if let y = conf!["y"] as? Double {
                particle.p.y = y
            }
        }
        
        if PropUtil.hasProp(conf, "vx") {
            if let vx = conf!["vx"] as? Double {
                particle.v.x = vx
            }
        }
        if PropUtil.hasProp(conf, "vy") {
            if let vy = conf!["vy"] as? Double {
                particle.v.y = vy
            }
        }
        
        if PropUtil.hasProp(conf, "ax") {
            if let ax = conf!["ax"] as? Double {
                particle.a.x = ax
            }
        }
        if PropUtil.hasProp(conf, "ay") {
            if let ay = conf!["ay"] as? Double {
                particle.a.y = ay
            }
        }
        
        if PropUtil.hasProp(conf, "p") {
            if let p = conf!["p"] as? Vector2D {
                particle.p.copy(p)
            }
        }
        if PropUtil.hasProp(conf, "v") {
            if let v = conf!["v"] as? Vector2D {
                particle.v.copy(v)
            }
        }
        if PropUtil.hasProp(conf, "a") {
            if let a = conf!["a"] as? Vector2D {
                particle.a.copy(a)
            }
        }
        
        if PropUtil.hasProp(conf, "position") {
            if let position = conf!["position"] as? Vector2D {
                particle.p.copy(position)
            }
        }
        if PropUtil.hasProp(conf, "velocity") {
            if let velocity = conf!["velocity"] as? Vector2D {
                particle.v.copy(velocity)
            }
        }
        if PropUtil.hasProp(conf, "accelerate") {
            if let accelerate = conf!["accelerate"] as? Vector2D {
                particle.a.copy(accelerate)
            }
        }
    }
}
