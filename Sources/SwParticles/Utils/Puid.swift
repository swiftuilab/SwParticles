import Foundation

/// Unique ID generator for particles and other objects
public class Puid {
    public var puid: String = ""
    
    private static var _idsMap: [String: Int] = [:]
    private static var _cacheMap: [String: Any] = [:]
    private static var _index: Int = 0
    
    public static func id(_ type: String) -> String {
        if Puid._idsMap[type] == nil {
            Puid._idsMap[type] = 0
        }
        let current = Puid._idsMap[type]!
        Puid._idsMap[type] = current + 1
        return "\(type)_\(current)"
    }
    
    public static func getId(_ target: Any) -> String {
        let uid = Puid.getIdFromCache(target)
        if uid != nil { return uid! }
        
        let newUid = "PUID_\(Puid._index)"
        Puid._index += 1
        Puid._cacheMap[newUid] = target
        return newUid
    }
    
    public static func getIdFromCache(_ target: Any) -> String? {
        var obj: Any?
        var id: String
        
        for id in Puid._cacheMap.keys {
            obj = Puid._cacheMap[id]
            
            if (obj as AnyObject) === (target as AnyObject) {
                return id
            }
            if Puid.isBody(obj, target) {
                // Check if both have src property and they match
                if let objDict = obj as? [String: Any],
                   let targetDict = target as? [String: Any],
                   let objSrc = objDict["src"],
                   let targetSrc = targetDict["src"],
                   (objSrc as AnyObject) === (targetSrc as AnyObject) {
                    return id
                }
            }
        }
        
        return nil
    }
    
    public static func isBody(_ obj: Any?, _ target: Any?) -> Bool {
        if obj is String { return false }
        if target is String { return false }
        if let objDict = obj as? [String: Any],
           let targetDict = target as? [String: Any] {
            let objIsInner = objDict["isInner"] as? Bool ?? false
            let targetIsInner = targetDict["isInner"] as? Bool ?? false
            return objIsInner && targetIsInner
        }
        return false
    }
    
    public static func getTarget(_ uid: String) -> Any? {
        return Puid._cacheMap[uid]
    }
}
