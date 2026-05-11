import Foundation

/// Utility functions
public struct Util {
    public static func initValue<T>(_ value: T?, _ defaults: T) -> T {
        return value != nil ? value! : defaults
    }
    
    public static func isArray(_ value: Any) -> Bool {
        return value is [Any]
    }
    
    public static func isNumeric(_ s: Any) -> Bool {
        return s is Double || s is Int
    }
    
    public static func toArray(_ arr: Any) -> [Any] {
        return Util.isArray(arr) ? (arr as! [Any]) : [arr]
    }
    
    public static func sliceArray(_ a: [Any], _ index: Int, _ b: inout [Any]) -> [Any] {
        b.removeAll()
        for i in index..<a.count {
            b.append(a[i])
        }
        
        return b
    }
    
    public static func getRandFromArray(_ list: [Any]?) -> Any? {
        if list == nil { return nil }
        
        return list![Int.random(in: 0..<list!.count)]
    }
    
    public static func getImageData(_ context: Any, _ image: Any, _ rect: Any) {
        //return ImgUtil.getImageData(context, image, rect);
    }
    
    public static func destroyAll(_ arr: [Any], _ param: Any?) {
        // Empty implementation
    }
}
