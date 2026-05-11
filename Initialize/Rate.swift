import Foundation

/// Rate class for controlling particle emission rate
public class Rate {
    public var startTime: Double = 0
    public var nextTime: Double = 0
    private var numPan: Span?
    private var timePan: Span?
    
    public init(_ numpan: Any? = nil, _ timepan: Any? = nil) {
        numPan = Span.setSpanValue(numpan ?? 1)
        timePan = Span.setSpanValue(timepan ?? 1)
        startTime = 0
        nextTime = 0
        initFunc()
    }
    
    public func initFunc() {
        startTime = 0
        let nextTimeValue = timePan?.getValue()
        nextTime = nextTimeValue as? Double ?? 1.0
    }
    
    public func getValue(_ time: Double) -> Int {
        startTime += time
        
        if startTime >= nextTime {
            startTime = 0
            let nextTimeValue = timePan?.getValue()
            nextTime = nextTimeValue as? Double ?? 1.0
            
            if let numPan = numPan, let b = numPan.b, b.toDouble() == 1 {
                let numValue = numPan.getValue(isInt: false)
                if let num = numValue as? Double {
                    if num > 0.5 {
                        return 1
                    } else {
                        return 0
                    }
                }
            } else {
                let intValue = numPan?.getValue(isInt: true)
                if let num = intValue as? Double {
                    return Int(num)
                } else if let num = intValue as? Int {
                    return num
                }
            }
            return 0
        }
        
        return 0
    }
}
