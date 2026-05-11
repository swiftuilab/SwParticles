import Foundation

/// Line zone for particle positioning
public class LineZone: Zone {
    public var x1: Double = 0.0
    public var y1: Double = 0.0
    public var x2: Double = 0.0
    public var y2: Double = 0.0
    public var dx: Double = 0.0
    public var dy: Double = 0.0
    public var minx: Double = 0.0
    public var maxx: Double = 0.0
    public var miny: Double = 0.0
    public var maxy: Double = 0.0
    public var dot: Double = 0.0
    public var xxyy: Double = 0.0
    public var gradient: Double = 0.0
    public var length: Double = 0.0
    public var direction: String = ""
    
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double, _ direction: String = ">") {
        super.init()
        if x2 - x1 >= 0 {
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
        } else {
            self.x1 = x2
            self.y1 = y2
            self.x2 = x1
            self.y2 = y1
        }
        
        self.dx = self.x2 - self.x1
        self.dy = self.y2 - self.y1
        
        self.minx = min(self.x1, self.x2)
        self.miny = min(self.y1, self.y2)
        self.maxx = max(self.x1, self.x2)
        self.maxy = max(self.y1, self.y2)
        
        self.dot = self.x2 * self.y1 - self.x1 * self.y2
        self.xxyy = self.dx * self.dx + self.dy * self.dy
        
        self.gradient = self.getGradient()
        self.length = self.getLength()
        self.direction = direction
    }
    
    public override func getPosition() -> Vector2D {
        random = MathUtil.random()
        vector.x = x1 + random * self.length * cos(gradient)
        vector.y = y1 + random * self.length * sin(gradient)
        
        return vector
    }
    
    public func getDirection(_ x: Double, _ y: Double) -> Bool {
        let A = dy
        let B = -dx
        let C = dot
        let D = B == 0 ? 1 : B
        
        if (A * x + B * y + C) * D > 0 {
            return true
        } else {
            return false
        }
    }
    
    public func getDistance(_ x: Double, _ y: Double) -> Double {
        let A = dy
        let B = -dx
        let C = dot
        let D = A * x + B * y + C
        
        return D / sqrt(xxyy)
    }
    
    public func getSymmetric(_ v: Vector2D) -> Vector2D {
        let tha2 = v.getGradient() ?? 0.0
        let tha1 = getGradient()
        let tha = 2 * (tha1 - tha2)
        
        let oldx = v.x
        let oldy = v.y
        
        v.x = oldx * cos(tha) - oldy * sin(tha)
        v.y = oldx * sin(tha) + oldy * cos(tha)
        
        return v
    }
    
    public func getGradient() -> Double {
        return atan2(dy, dx)
    }
    
    public func rangeOut(_ particle: Particle) -> Bool {
        let angle = abs(gradient)
        
        if angle <= MathUtil.PI / 4 {
            if particle.p.x <= self.maxx && particle.p.x >= self.minx {
                return true
            }
        } else {
            if particle.p.y <= self.maxy && particle.p.y >= self.miny {
                return true
            }
        }
        
        return false
    }
    
    public func getLength() -> Double {
        return sqrt(dx * dx + dy * dy)
    }
    
    public override func crossing(_ particle: Particle) {
        if crossType == "dead" {
            if direction == ">" || direction == "R" || direction == "right" || direction == "down" {
                if !rangeOut(particle) { return }
                if getDirection(particle.p.x, particle.p.y) {
                    particle.dead = true
                }
            } else {
                if !rangeOut(particle) { return }
                if !getDirection(particle.p.x, particle.p.y) {
                    particle.dead = true
                }
            }
        } else if crossType == "bound" {
            if !rangeOut(particle) { return }
            
            if getDistance(particle.p.x, particle.p.y) <= particle.radius {
                if dx == 0 {
                    particle.v.x *= -1
                } else if dy == 0 {
                    particle.v.y *= -1
                } else {
                    _ = getSymmetric(particle.v)
                }
            }
        } else if crossType == "cross" {
            if alert {
                print("Sorry, LineZone does not support cross method!")
                alert = false
            }
        }
    }
}
