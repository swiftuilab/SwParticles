import Foundation
import SwiftUI

/// Body initializer for particle images
public class Body: Initialize {
    private var image: Span?
    public var w: Double = 0
    public var h: Double = 0
    
    public init(_ image: Any, _ w: Double = 20, _ h: Double = 0) {
        super.init()
        self.image = setSpanValue(image)
        self.w = w
        self.h = h == 0 ? w : h
        name = "Body"
    }
    
    public override func initialize(_ target: PBody) {
        guard let particle = target as? Particle else { return }
        let url = image?.getValue() as? String ?? ""
        particle.body = url
        particle.data.imgUrl = url
        particle.data.useImage = true
        particle.renderType = "image"
    }
    
    private func setSpanValue(_ image: Any) -> Span? {
        if let span = image as? ArraySpan {
            return span
        } else {
            return ArraySpan.createArraySpan(image) ?? ArraySpan(image)
        }
    }
}
