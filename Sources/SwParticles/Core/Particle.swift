import Foundation
import SwiftUI

/// Represents a particle in the particle system
public class Particle: PBody, Poolable {
    public var id: String?
    public var name: String = ""
    public var old: PBody?
    
    public var behaviours: [Behaviour] = []
    public var dead: Bool = false
    public var sleep: Bool = false
    public weak var parent: AnyObject?
    
    public required override init() {
        super.init()
        name = "Particle"
        id = Puid.id(name)
        old = PBody()
        self.reset()
    }
    
    /// Pool ID for object pooling
    public var poolId: String {
        return id ?? ""
    }
    
    public override func getDirection() -> Double {
        return atan2(self.v.x, -self.v.y) * MathUtil.N180_PI
    }
    
    public func update(_ time: Double, _ index: Int? = nil) {
        if !self.sleep {
            self.age += time
            self.applyBehaviours(time, index)
        }
        
        if self.age < self.life {
            let scale = self.age / self.life
            //const scale = this.easing(this.age / this.life);
            self.energy = max(1 - scale, 0)
        } else {
            self.release()
        }
    }
    
    public func applyBehaviours(_ time: Double, _ index: Int?) {
        let length = self.behaviours.count
        var i: Int
        
        for i in 0..<length {
            if self.behaviours[i] != nil {
                self.behaviours[i].applyBehaviour(self, time, index ?? 0)
            }
        }
    }
    
    public func addBehaviour(_ behaviour: Behaviour) {
        self.behaviours.append(behaviour)
        behaviour.parents.append(self)
        behaviour.initialize(self)
    }
    
    public func addBehaviours(_ behaviours: [Behaviour]) {
        let length = behaviours.count
        var i: Int
        
        for i in 0..<length {
            self.addBehaviour(behaviours[i])
        }
    }
    
    public func removeBehaviour(_ behaviour: Behaviour) {
        if let index = self.behaviours.firstIndex(where: { $0 === behaviour }) {
            self.behaviours.remove(at: index)
            if let parentIndex = behaviour.parents.firstIndex(where: { ($0 as? AnyObject) === (self as AnyObject) }) {
                behaviour.parents.remove(at: parentIndex)
            }
        }
    }
    
    public func removeAllBehaviours() {
        self.behaviours.removeAll()
    }
    
    public func release() {
        self.removeAllBehaviours()
        self.energy = 0
        self.dead = true
        self.parent = nil
    }
    
    public override func destroy() {
        self.release()
        super.destroy()
        self.old?.destroy()
        self.data.destroy()
        self.old = nil
        self.body = nil
    }
    
    public override func reset() {
        life = Double.infinity
        age = 0
        
        renderColorOnce = false
        dead = false
        sleep = false
        body = nil
        parent = nil
        
        energy = 1 // Energy Loss
        mass = 1
        radius = 10
        alpha = 1
        self.scale = 1
        self.rotation = 0
        self.color = PColor(255, 255, 255, 255)
        
        super.reset()
        self.old?.reset()
        self.data.reset()
        self.removeAllBehaviours()
    }
}

/// Make Particle poolable
extension Particle: PoolableInitializable {
    public static func create() -> Self {
        return Self()
    }
}
