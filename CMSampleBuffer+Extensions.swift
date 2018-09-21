
import CoreMedia

extension CMSampleBuffer {
        
    /// Returns this sample buffer's presentation timestamp.
    ///
    /// - Returns: The `CMTime` value this `CMSampleBuffer` contains for it's presentation time.
    public func presentationTime() -> CMTime {
        return CMSampleBufferGetPresentationTimeStamp(self)
    }
    
    /// Returns a copy of this sample buffer with it's timestamp replaced with the provided CMTime value.
    ///
    /// - Parameter newTime: The CMTime you want to use for the new sample buffer.
    /// - Returns: A duplicate CMSampleBuffer with new presentation time - nil if something went wrong.
    public func copyWithNewPresentationTime(_ newTime: CMTime) -> CMSampleBuffer? {
        
        var timingInfo = CMSampleTimingInfo.invalid
        
        timingInfo.duration = CMSampleBufferGetDuration(self)
        timingInfo.presentationTimeStamp = newTime

        var newAudioBuffer: CMSampleBuffer? = nil

        CMSampleBufferCreateCopyWithNewTiming(allocator: kCFAllocatorDefault, sampleBuffer: self, sampleTimingEntryCount: 1, sampleTimingArray: &timingInfo, sampleBufferOut: &newAudioBuffer)

        return newAudioBuffer
    }
    
}
