import Foundation
import SwiftUI

public class CanvasRenderer: BaseRenderer {
    
    public override func renderParticle(_ particle: Particle, in context: inout GraphicsContext) {
        switch particle.renderType {
        case "image":
            renderImage(particle, in: &context)
        case "rect":
            renderRectangle(particle, in: &context)
        case "star":
            renderStar(particle, in: &context)
        case "polygon":
            renderPolygon(particle, in: &context)
        case "circle", "":
            renderCircle(particle, in: &context)
        default:
            renderCircle(particle, in: &context)
        }
    }
    
    public override func renderCircle(_ particle: Particle, in context: inout GraphicsContext) {
        let r = CGFloat(particle.radius * particle.scale)
        
        if r > 0 && particle.alpha > 0.01 {
            let rect = CGRect(
                x: CGFloat(particle.p.x) - r,
                y: CGFloat(particle.p.y) - r,
                width: r * 2,
                height: r * 2
            )
            
            var path = Path()
            path.addEllipse(in: rect)
            
            let savedBlendMode = context.blendMode
            if let blendMode = particle.data.blendMode {
                context.blendMode = blendMode
            }
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
            
            context.blendMode = savedBlendMode
        }
    }
    
    public override func renderRectangle(_ particle: Particle, in context: inout GraphicsContext) {
        let w: CGFloat
        let h: CGFloat
        
        if particle.renderType == "rect" && particle.data.rectWidth > 0 && particle.data.rectHeight > 0 {
            w = CGFloat(particle.data.rectWidth * particle.scale)
            h = CGFloat(particle.data.rectHeight * particle.scale)
        } else {
            let size = CGFloat(particle.data.rect2 * particle.scale)
            let r = CGFloat(particle.radius * particle.scale)
            w = size > 0 ? size : r * 2
            h = size > 0 ? size : r * 2
        }
        
        if w > 0 && h > 0 && particle.alpha > 0.01 {
            let rect = CGRect(
                x: CGFloat(particle.p.x) - w / 2,
                y: CGFloat(particle.p.y) - h / 2,
                width: w,
                height: h
            )
            
            var path = Path()
            path.addRect(rect)
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
            
            let savedBlendMode = context.blendMode
            if let blendMode = particle.data.blendMode {
                context.blendMode = blendMode
            }
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
            
            context.blendMode = savedBlendMode
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(-particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
        }
    }
    
    public override func renderImage(_ particle: Particle, in context: inout GraphicsContext) {
        guard let body = particle.body as? String else {
            renderCircle(particle, in: &context)
            return
        }
        
        let image = Image(body)
        
        let savedBlendMode = context.blendMode
        if let blendMode = particle.data.blendMode {
            context.blendMode = blendMode
        }
        
        context.opacity = particle.alpha
        
        context.translateBy(x: particle.p.x, y: particle.p.y)
        
        if particle.rotation != 0 {
            context.rotate(by: .degrees(particle.rotation * 180.0 / .pi))
        }
        
        if particle.scale != 1.0 {
            context.scaleBy(x: particle.scale, y: particle.scale)
        }
        
        context.draw(image, at: CGPoint(x: 0, y: 0), anchor: .center)
        
        if particle.scale != 1.0 {
            context.scaleBy(x: 1.0 / particle.scale, y: 1.0 / particle.scale)
        }
        
        if particle.rotation != 0 {
            context.rotate(by: .degrees(-particle.rotation * 180.0 / .pi))
        }
        
        context.translateBy(x: -particle.p.x, y: -particle.p.y)
        
        context.blendMode = savedBlendMode
        context.opacity = 1.0
    }
    
    public func renderStar(_ particle: Particle, in context: inout GraphicsContext) {
        let r = CGFloat(particle.radius * particle.scale)
        let count = particle.data.count > 0 ? particle.data.count : 5
        
        if r > 0 && particle.alpha > 0.01 {
            var path = Path()
            let outerRadius = r
            let innerRadius = r * 0.5
            let centerX = CGFloat(particle.p.x)
            let centerY = CGFloat(particle.p.y)
            let angleStep = Double.pi * 2.0 / Double(count * 2)
            
            for i in 0..<(count * 2) {
                let angle = angleStep * Double(i) - Double.pi / 2.0
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = centerX + CGFloat(cos(angle)) * radius
                let y = centerY + CGFloat(sin(angle)) * radius
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
            
            let savedBlendMode = context.blendMode
            if let blendMode = particle.data.blendMode {
                context.blendMode = blendMode
            }
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
            
            context.blendMode = savedBlendMode
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(-particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
        }
    }
    
    public func renderPolygon(_ particle: Particle, in context: inout GraphicsContext) {
        let r = CGFloat(particle.radius * particle.scale)
        let count = particle.data.count > 0 ? particle.data.count : 5
        
        if r > 0 && particle.alpha > 0.01 {
            var path = Path()
            let centerX = CGFloat(particle.p.x)
            let centerY = CGFloat(particle.p.y)
            let angleStep = Double.pi * 2.0 / Double(count)
            
            for i in 0..<count {
                let angle = angleStep * Double(i) - Double.pi / 2.0
                let x = centerX + CGFloat(cos(angle)) * r
                let y = centerY + CGFloat(sin(angle)) * r
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.closeSubpath()
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
            
            let savedBlendMode = context.blendMode
            if let blendMode = particle.data.blendMode {
                context.blendMode = blendMode
            }
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
            
            context.blendMode = savedBlendMode
            
            if particle.rotation != 0 {
                context.translateBy(x: particle.p.x, y: particle.p.y)
                context.rotate(by: .degrees(-particle.rotation * 180.0 / .pi))
                context.translateBy(x: -particle.p.x, y: -particle.p.y)
            }
        }
    }
}
