//
//  AVAsset+VideoOrientation.swift
//
//  Created by Wesley Van der Klomp on 1/7/19.
//

// Translated from: https://gist.github.com/lukabernardi/5020724

import AVFoundation

extension AVAsset {
    
    enum VideoOrientation {
        case right, up, left, down
        
        static func fromVideoWithAngle(ofDegree degree: CGFloat) -> VideoOrientation? {
            switch Int(degree) {
            case 0: return .right
            case 90: return .up
            case 180: return .left
            case -90: return .down
            default: return nil
            }
        }
    }
    
    func videoOrientation() -> VideoOrientation? {
        func radiansToDegrees(_ radians: Float) -> CGFloat {
            return CGFloat(radians * 180.0 / Float.pi)
        }
        
        guard let firstVideoTrack = self.tracks(withMediaType: .video).first else {
            return nil
        }
        let transform = firstVideoTrack.preferredTransform
        let videoAngleInDegree = radiansToDegrees(atan2f(Float(transform.b), Float(transform.a)))
        return VideoOrientation.fromVideoWithAngle(ofDegree: videoAngleInDegree)
    }
    
}
