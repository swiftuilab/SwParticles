import Foundation

/// Event listener type
public typealias EventListener = (Any?) -> Bool

/// Event dispatcher for handling events
public class EventDispatcher {
    private var _listeners: [String: [EventListener]]?
    
    /// Add event listener (alias for addEventListener)
    @discardableResult
    public func on(_ type: String, _ listener: @escaping EventListener) -> EventListener {
        return addEventListener(type, listener)
    }
    
    /// Remove event listener (alias for removeEventListener)
    public func removeListener(_ type: String, _ listener: @escaping EventListener) {
        removeEventListener(type, listener)
    }
    
    /// Add event listener
    @discardableResult
    public func addEventListener(_ type: String, _ listener: @escaping EventListener) -> EventListener {
        if self._listeners == nil {
            self._listeners = [:]
        } else {
            _removeEventListener(type, listener)
        }
        
        if self._listeners?[type] == nil {
            self._listeners?[type] = []
        }
        self._listeners?[type]?.append(listener)
        
        return listener
    }
    
    /// Remove event listener
    public func removeEventListener(_ type: String, _ listener: @escaping EventListener) {
        _removeEventListener(type, listener)
    }
    
    private func _removeEventListener(_ type: String, _ listener: @escaping EventListener) {
        if self._listeners == nil { return }
        if self._listeners?[type] == nil { return }
        
        guard var arr = self._listeners?[type] else { return }
        let length = arr.count
        
        for i in 0..<length {
            // Compare function references
            if arr[i] as AnyObject === listener as AnyObject {
                if length == 1 {
                    self._listeners?.removeValue(forKey: type)
                } else {
                    arr.remove(at: i)
                    self._listeners?[type] = arr
                }
                break
            }
        }
    }
    
    /// Remove all event listeners
    public func removeAllEventListeners(_ type: String? = nil) {
        if type == nil {
            self._listeners = nil
        } else if self._listeners != nil {
            self._listeners?.removeValue(forKey: type!)
        }
    }
    
    /// Dispatch event
    public func dispatchEvent(_ type: String, _ args: Any?) {
        guard let listeners = self._listeners else { return }
        guard var arr = listeners[type] else { return }
        
        // arr = arr.slice();
        // to avoid issues with items being removed or added during the dispatch
        
        var handler: EventListener
        var i = arr.count - 1
        while i >= 0 {
            handler = arr[i]
            if args == nil {
                _ = handler(nil)
            } else {
                _ = handler(args)
            }
            i -= 1
        }
    }
    
    /// Check if has event listener
    public func hasEventListener(_ type: String) -> Bool {
        guard let listeners = self._listeners else { return false }
        return listeners[type] != nil
    }
}

/// Protocol for event dispatching
public protocol EventDispatching {
    func dispatchEvent(_ type: String, _ args: Any?)
    @discardableResult func addEventListener(_ type: String, _ listener: @escaping EventListener) -> EventListener
    func removeEventListener(_ type: String, _ listener: @escaping EventListener)
    func removeAllEventListeners(_ type: String?)
    func hasEventListener(_ type: String) -> Bool
}

/// Extension to make EventDispatcher conform to EventDispatching
extension EventDispatcher: EventDispatching {}
