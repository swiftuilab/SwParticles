import Foundation

/// Object pool for caching and reusing particles
public class Pool {
    public var total: Int = 0
    public var poolIndex: Int = 0
    private var cache: [String: [Any]] = [:]
    public var create: (Any?, Any?) -> Any? = { _, _ in nil }
    
    public init(_ num: Int? = nil) {
    }
    
    /// Get object from pool or create new one
    public func get(_ name: String, _ param1: Any? = nil, _ param2: Any? = nil) -> Any? {
        var p: Any?
        if hasCache(name) {
            if var cached = cache[name], !cached.isEmpty {
                p = cached.removeLast()
                cache[name] = cached
            }
        } else {
            p = createNewOne(param1, param2)
        }
        
        return p
    }
    
    /// Return object to pool
    public func expire(_ key: String, _ target: Any) {
        if cache[key] == nil {
            cache[key] = []
        }
        cache[key]?.append(target)
    }
    
    /// Create new object
    public func createNewOne(_ param1: Any?, _ param2: Any?) -> Any? {
        total += 1
        return create(param1, param2)
    }
    
    /// Get count of cached objects
    public func getCount() -> Int {
        var count = 0
        cache.forEach { (id, v) in
            count += cache[id]?.count ?? 0
        }
        return count
    }
    
    /// Destroy pool
    public func destroy() {
        cache.removeAll()
    }
    
    /// Get cache for name
    public func getCache(_ name: String = "default") -> [Any] {
        if cache[name] == nil {
            cache[name] = []
        }
        return cache[name]!
    }
    
    /// Check if cache exists and has items
    public func hasCache(_ name: String) -> Bool {
        return cache[name] != nil && (cache[name]?.count ?? 0) > 0
    }
    
    /// Get cache number
    public func getCacheNum() -> Int {
        var num = 0
        for key in cache.keys {
            num += cache[key]?.count ?? 0
        }
        return num
    }
}

extension Pool: CustomStringConvertible {
    public var description: String {
        return "Pool:t:\(total) - p:\(getCacheNum())"
    }
}

/// Protocol for objects that can be pooled
public protocol Poolable {
    var poolId: String { get }
    func reset()
}

/// Protocol for types that can be initialized for pooling
public protocol PoolableInitializable {
    static func create() -> Self
}
