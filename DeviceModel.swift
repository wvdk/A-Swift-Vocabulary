import Foundation

/// An enum representing a hardware model of iPhone or iPad. You can convert from a model name (or "ID") string to one of these enum valies via `model(for id: String)`.
///
/// **Important note:** This list needs to be updated when new versions are released. Until this list is updated (and users have a updated version of this app) new devices will default to `.unknown`. So it's very important that you develop your device-dependent systems with reasonable fallbacks for `.unknown`.
public enum DeviceModel {
    
    case iPhone // "iPhone1,1"
    case iPhone3G // "iPhone1,2"
    case iPhone3GS // "iPhone2,1"
    case iPhone4 // "iPhone3,1", "iPhone3,2", "iPhone3,3"
    case iPhone4S // "iPhone4,1", "iPhone4,2", "iPhone4,3"
    case iPhone5 // "iPhone5,1", "iPhone5,2"
    case iPhone5C // "iPhone5,3", "iPhone5,4"
    case iPhone5S // "iPhone6,1", "iPhone6,2"
    case iPhone6 // "iPhone7,2"
    case iPhone6Plus // "iPhone7,1"
    case iPhone6S // "iPhone8,1"
    case iPhone6SPlus // "iPhone8,2"
    case iPhoneSE // "iPhone8,4"
    case iPhone7 // "iPhone9,1", "iPhone9,3"
    case iPhone7Plus // "iPhone9,2", "iPhone9,4"
    case iPhone8 // "iPhone10,1", "iPhone10,4"
    case iPhone8Plus // "iPhone10,2", "iPhone10,5"
    case iPhoneX // "iPhone10,3", "iPhone10,6"
    case iPhoneXs // "iPhone11,2"
    case iPhoneXsMax // "iPhone11,4", "iPhone11,6"
    case iPhoneXʀ // "iPhone11,8"
    case iPhone11 // "iPhone12,1"
    case iPhone11Pro // "iPhone12,3"
    case iPhone11ProMax // "iPhone12,5"
    case iPad // "iPad1,1"
    case iPad2 // "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4"
    case iPad3 // "iPad3,1", "iPad3,2", "iPad3,3"
    case iPad4 // "iPad3,4", "iPad3,5", "iPad3,6"
    case iPad5 // "iPad6,11", "iPad6,12"
    case iPad6 // "iPad7,5", "iPad7,6"
    case iPad7 // "iPad7,11", "iPad7,12"
    case iPadAir // "iPad4,1", "iPad4,2", "iPad4,3"
    case iPadAir2 // "iPad5,3", "iPad5,4"
    case iPadAir3 // "iPad11,3", "iPad11,4"
    case iPadMini // "iPad2,5", "iPad2,6", "iPad2,7"
    case iPadMini2 // "iPad4,4", "iPad4,5", "iPad4,6"
    case iPadMini3 // "iPad4,7", "iPad4,8", "iPad4,9"
    case iPadMini4 // "iPad5,1", "iPad5,2"
    case iPadMini5 // "iPad11,1", "iPad11,2"
    case iPadPro9_7Inch // "iPad6,3", "iPad6,4"
    case iPadPro10_5Inch // "iPad7,3", "iPad7,4"
    case iPadPro11InchCaseUnknown // "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4"
    case iPadPro12_9Inch // "iPad6,7", "iPad6,8"
    case iPadPro12_9Inch2 // "iPad7,1", "iPad7,2"
    case iPadPro12_9Inch3 // "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"
    case unknown
    
    static func model(for id: String) -> DeviceModel  {
        switch id {
        case "iPhone1,1": return iPhone
        case "iPhone1,2": return iPhone3G
        case "iPhone2,1": return iPhone3GS
        case "iPhone3,1", "iPhone3,2":  return iPhone4
        case "iPhone4,1", "iPhone4,2":  return iPhone4S
        case "iPhone5,1", "iPhone5,2": return iPhone5
        case "iPhone5,3", "iPhone5,4": return iPhone5C
        case "iPhone6,1", "iPhone6,2": return iPhone5S
        case "iPhone7,2": return iPhone6
        case "iPhone7,1": return iPhone6Plus
        case "iPhone8,1": return iPhone6S
        case "iPhone8,2": return iPhone6SPlus
        case "iPhone8,4": return iPhoneSE
        case "iPhone9,1", "iPhone9,3": return iPhone7
        case "iPhone9,2", "iPhone9,4": return iPhone7Plus
        case "iPhone10,1", "iPhone10,4": return iPhone8
        case "iPhone10,2", "iPhone10,5": return iPhone8Plus
        case "iPhone10,3", "iPhone10,6": return iPhoneX
        case "iPhone11,2": return iPhoneXs
        case "iPhone11,4", "iPhone11,6": return iPhoneXsMax
        case "iPhone11,8": return iPhoneXʀ
        case "iPhone12,1": return iPhone11
        case "iPhone12,3": return iPhone11Pro
        case "iPhone12,5": return iPhone11ProMax
        case "iPad1,1": return iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": return iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": return iPad4
        case "iPad6,11", "iPad6,12": return iPad5
        case "iPad7,5", "iPad7,6": return iPad6
        case "iPad7,11", "iPad7,12": return iPad7
        case "iPad4,1", "iPad4,2", "iPad4,3": return iPadAir
        case "iPad5,3", "iPad5,4": return iPadAir2
        case "iPad11,3", "iPad11,4": return iPadAir3
        case "iPad2,5", "iPad2,6", "iPad2,7": return iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": return iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": return iPadMini3
        case "iPad5,1", "iPad5,2": return iPadMini4
        case "iPad11,1", "iPad11,2": return iPadMini5
        case "iPad6,3", "iPad6,4": return iPadPro9_7Inch
        case "iPad7,3", "iPad7,4": return iPadPro10_5Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return iPadPro11InchCaseUnknown
        case "iPad6,7", "iPad6,8": return iPadPro12_9Inch
        case "iPad7,1", "iPad7,2": return iPadPro12_9Inch2
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return iPadPro12_9Inch3
        default: return .unknown
        }
    }
    
}
