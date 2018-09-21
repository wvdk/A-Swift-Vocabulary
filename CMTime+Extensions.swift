
import Foundation
import AVFoundation

public protocol PrettyPrint {
    func prettyPrint() -> String
}

extension CMTime: PrettyPrint {
    public func prettyPrint() -> String {
        let timeStr = String(format: "%d / %d", self.value, self.timescale)
        if self.flags != CMTimeFlags.valid {
            return timeStr + ", flags: \(CMTimeFlags(rawValue: self.flags.rawValue))"
        }
        return timeStr
    }
}

extension CMTimeRange: PrettyPrint {
    public func prettyPrint() -> String {
        return "\(self.start.prettyPrint()) -> \(self.end.prettyPrint())"
    }
}

public func CMTimeRangeMake(start: CMTime, end: CMTime) -> CMTimeRange {
    return CMTimeRangeMake(start: start, duration: CMTimeSubtract(end, start))
}
