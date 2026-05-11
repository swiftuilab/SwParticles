import Foundation

/// Date utility functions
public struct DateUtil {
    public static func now() -> Double {
        return Date().timeIntervalSince1970 * 1000.0
    }
}
