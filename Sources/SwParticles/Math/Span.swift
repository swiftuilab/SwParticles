import Foundation
import CoreGraphics

/// Represents possible values for Span
public enum SpanValue {
    case span(Span)
    case array([Any])
    case double(Double)
    
    /// Convert Any to SpanValue
    static func fromAny(_ value: Any?) -> SpanValue {
        guard let value = value else {
            return .double(1.0)
        }
        
        if let span = value as? Span {
            return .span(span)
        } else if let array = value as? [Any] {
            return .array(array)
        } else if let double = value as? Double {
            return .double(double)
        } else if let cgFloat = value as? CGFloat {
            return .double(Double(cgFloat))
        } else if let int = value as? Int {
            return .double(Double(int))
        } else {
            // Default to 1.0 if type is unknown
            return .double(1.0)
        }
    }
    
    /// Get Double value from SpanValue
    func toDouble() -> Double {
        switch self {
        case .span(let span):
            if let value = span.getValue() as? Double {
                return value
            }
            return 1.0
        case .array(let array):
            if let value = Util.getRandFromArray(array) as? Double {
                return value
            } else if let value = Util.getRandFromArray(array) as? Int {
                return Double(value)
            }
            return 1.0
        case .double(let value):
            return value
        }
    }
    
    /// Check if this is an array
    var isArray: Bool {
        if case .array = self {
            return true
        }
        return false
    }
}

/// Represents a span of values or an array
public class Span {
    public var isArray: Bool = false
    public var center: Bool = false
    public var a: SpanValue
    public var b: SpanValue?
    
    public init(_ a: Any? = nil, _ b: Any? = nil, center: Bool = false) {
        let aValue = SpanValue.fromAny(a)
        self.a = aValue
        self.isArray = aValue.isArray
        
        if let bValue = b {
            self.b = SpanValue.fromAny(bValue)
        } else {
            self.b = self.a
        }
        self.center = center
    }
    
    public func getValue(isInt: Bool = false) -> Any {
        if isArray {
            if case .array(let array) = a {
                return Util.getRandFromArray(array) ?? 0
            }
            return 0
        } else {
            let aDouble = a.toDouble()
            let bDouble = b?.toDouble() ?? aDouble
            
            if !center {
                return MathUtil.randomAToB(aDouble, bDouble, isInt: isInt)
            } else {
                return MathUtil.randomFloating(aDouble, bDouble, isInt: isInt)
            }
        }
    }
    
    public static func setSpanValue(_ a: Any, _ b: Any? = nil, _ c: Bool? = nil) -> Span {
        if let span = a as? Span {
            return span
        } else {
            if b == nil {
                return Span(a)
            } else {
                if let centerValue = c {
                    return Span(a, b, center: centerValue)
                } else {
                    return Span(a, b)
                }
            }
        }
    }
    
    public static func getSpanValue(_ pan: Any) -> Any {
        if let span = pan as? Span {
            return span.getValue()
        }
        return pan
    }
}
