import Foundation

private let CHANGING = "changing"

public class Cyclone: Behaviour {
    public var force: Any = ""
    public var angle: Any = 0.0
    public var span: Span?
    
    public init(_ angle: Any? = nil, _ force: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        super.init(life, easing)
        setAngleAndForce(angle, force)
        name = "Cyclone"
    }
    
    public func setAngleAndForce(_ angle: Any?, _ force: Any?) {
        self.force = CHANGING
        self.angle = MathUtil.PI_2
        
        if let angleStr = angle as? String {
            if angleStr == "right" {
                self.angle = MathUtil.PI_2
            } else if angleStr == "left" {
                self.angle = -MathUtil.PI_2
            } else if angleStr == "random" {
                self.angle = "random"
            }
        } else if let angleSpan = angle as? Span {
            self.angle = "span"
            self.span = angleSpan
        } else if angle != nil {
            self.angle = angle!
        }
        
        if let forceStr = force as? String {
            let newForce = forceStr.lowercased()
            if newForce == "changing" || newForce == "chang" || newForce == "auto" {
                self.force = CHANGING
            } else {
                self.force = force!
            }
        } else if force != nil {
            self.force = force!
        }
    }
    
    public func reset(_ angle: Any? = nil, _ force: Any? = nil, _ life: Any? = nil, _ easing: String? = nil) {
        self.angle = MathUtil.PI_2
        setAngleAndForce(angle, force)
        if life != nil {
            super.reset(life, easing)
        }
    }
    
    public override func initialize(_ particle: PBody) {
        guard let particle = particle as? Particle else { return }
        if let angleStr = angle as? String, angleStr == "random" {
            let cangleValue = MathUtil.randomAToB(-MathUtil.PI, MathUtil.PI)
            particle.data.cangle = cangleValue as? Double
        } else if let angleStr = angle as? String, angleStr == "span" {
            let cangleValue = span?.getValue()
            particle.data.cangle = cangleValue as? Double
        }
        
        particle.data.cyclone = Vector2D(0.0, 0.0)
    }
    
    public override func applyBehaviour(_ particle: PBody, _ time: Double, _ index: Int?) {
        guard let particle = particle as? Particle else { return }
        calculate(particle, time, index)
        
        var length: Double
        var gradient = particle.v.getGradient() ?? 0.0
        if let angleStr = angle as? String, (angleStr == "random" || angleStr == "span") {
            if let cangle = particle.data.cangle {
                gradient += cangle
            }
        } else if let angleNum = angle as? Double {
            gradient += angleNum
        }
        
        if let forceStr = force as? String, forceStr == CHANGING {
            length = particle.v.length() / 100
        } else if let forceNum = force as? Double {
            length = forceNum
        } else {
            length = 0
        }
        
        particle.data.cyclone.x = length * cos(gradient)
        particle.data.cyclone.y = length * sin(gradient)
        particle.data.cyclone = normalizeForce(particle.data.cyclone)
        particle.a.add(particle.data.cyclone)
    }
}
