import Foundation
import SwiftUI

/// Data class for storing particle additional data
public class Data {
    public var colorA: PColor?
    public var colorB: PColor?
    public var imgUrl: String = ""
    public var mark: String?
    public var shape: String = "circle"
    public var useImage: Bool = false
    
    public var cangle: Double?
    public var cyclone: Vector2D = Vector2D(0, 0)
    public var alphaA: Double = 1
    public var alphaB: Double = 1
    public var time: Double = 0
    public var rotationA: Double = 0
    public var rotationB: Double = 0
    public var scaleA: Double = 1
    public var scaleB: Double = 1
    public var oldRadius: Double = 0
    
    public var x: Double = 0
    public var y: Double = 0
    public var value: Double = 0
    public var speed: Double = 0
    public var rect2: Double = 2
    public var rectWidth: Double = 0
    public var rectHeight: Double = 0
    public var alpha: Double = 1
    public var radius: Double = 0
    public var angle: Double = 0
    public var delay: Double = 0
    public var scale: Double = 1
    public var dynamic: Double = 0
    
    public var index: Int = 0
    public var count: Int = 0
    public var open: Bool = false
    public var blendMode: GraphicsContext.BlendMode?
    
    public init() {
    }
    
    public func reset() {
        colorA = nil
        colorB = nil
        mark = nil
        shape = "circle"
        imgUrl = ""
        
        cangle = nil
        alphaA = 1
        alphaB = 1
        time = 0
        rotationA = 0
        rotationB = 0
        scaleA = 1
        scaleB = 1
        scale = 1
        dynamic = 0
        
        delay = 0
        oldRadius = 0
        rect2 = 2
        rectWidth = 0
        rectHeight = 0
        index = 0
        count = 0
        angle = 0
        
        x = 0
        y = 0
        value = 0
        speed = 0
        alpha = 1
        radius = 0
        open = false
        useImage = false
        blendMode = nil
    }
    
    public func destroy() {
        reset()
    }
}

