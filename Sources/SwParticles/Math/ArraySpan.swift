import Foundation

/// ArraySpan - a span that works with arrays
public class ArraySpan: Span {
    private var _arr: [Any] = []
    
    public init(_ color: Any) {
        super.init(color)
        self._arr = Util.toArray(color)
    }
    
    public override func getValue(isInt: Bool = false) -> Any {
        let val = Util.getRandFromArray(self._arr)
        if let str = val as? String, (str == "random" || str == "Random") {
            return MathUtil.randomColor()
        }
        return val ?? 0
    }
    
    public static func createArraySpan(_ arr: Any?) -> ArraySpan? {
        if arr == nil { return nil }
        
        if let span = arr as? ArraySpan {
            return span
        } else {
            return ArraySpan(arr!)
        }
    }
}
