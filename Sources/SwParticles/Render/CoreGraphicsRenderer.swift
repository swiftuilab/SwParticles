import Foundation
import SwiftUI
import CoreGraphics
import UIKit

public class CoreGraphicsRenderer: BaseRenderer {
    
    public override func renderParticle(_ particle: Particle, in context: inout GraphicsContext) {
        if particle.body != nil && particle.data.useImage {
            renderImage(particle, in: &context)
            return
        }
        
        let shape = particle.data.shape
        switch shape {
        case "rect2":
            renderRectangle(particle, in: &context)
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
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
        }
    }
    
    public override func renderRectangle(_ particle: Particle, in context: inout GraphicsContext) {
        let size = CGFloat(particle.data.rect2 * particle.scale)
        let r = CGFloat(particle.radius * particle.scale)
        let w = size > 0 ? size : r * 2
        let h = size > 0 ? size : r * 2
        
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
            
            context.opacity = particle.alpha
            let pColor = particle.color
            let color = Color(
                red: Double(pColor.red) / 255.0,
                green: Double(pColor.green) / 255.0,
                blue: Double(pColor.blue) / 255.0,
                opacity: Double(pColor.alpha) / 255.0
            )
            context.fill(path, with: .color(color))
            
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
        
        guard let uiImage = UIImage(named: body),
              let cgImage = uiImage.cgImage else {
            renderCircle(particle, in: &context)
            return
        }
        
        let w = Double(cgImage.width) * particle.scale
        let h = Double(cgImage.height) * particle.scale
        let x = particle.p.x - w / 2
        let y = particle.p.y - h / 2
        
        context.opacity = particle.alpha
        if particle.rotation != 0 {
            context.translateBy(x: particle.p.x, y: particle.p.y)
            context.rotate(by: .degrees(particle.rotation * 180.0 / .pi))
            context.translateBy(x: -particle.p.x, y: -particle.p.y)
        }
        
        context.draw(image, in: CGRect(x: x, y: y, width: w, height: h))
        
        context.opacity = 1.0
        if particle.rotation != 0 {
            context.translateBy(x: particle.p.x, y: particle.p.y)
            context.rotate(by: .degrees(-particle.rotation * 180.0 / .pi))
            context.translateBy(x: -particle.p.x, y: -particle.p.y)
        }
    }
}
