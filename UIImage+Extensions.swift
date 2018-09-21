import UIKit

extension UIImage {

    func getImages(minimumWidths: [CGFloat]) -> [UIImage] {
        var output: [UIImage] = []
        for width in minimumWidths {
            output.append(self.resize(to: CGSize(width: width, height: width * self.size.height / self.size.width)))
        }
        return output
    }
    
    func getImages(minimumHeights: [CGFloat]) -> [UIImage] {
        var output: [UIImage] = []
        for height in minimumHeights {
            output.append(self.resize(to: CGSize(width: height * self.size.width / self.size.height, height: height)))
        }
        return output
    }
    
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func asPixelBuffer() -> CVPixelBuffer? {
        let image = self
        
        let attrs = [kCVPixelBufferMetalCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
}



import SDWebImage

//  Created by Austin Fitzpatrick on 5/1/18.
extension UIImage {
   
    static func createWithInitials(initials:String, size: CGSize) -> UIImage? {
        
        guard initials.count <= 2 else {
            Log.e("Error - Two initials is the maximum")
            return nil
        }
        
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.addPath(UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).cgPath)
        context.clip()
        context.setFillColor(UIColor(sketch: (239,239,239)).cgColor)
        context.fill(CGRect(origin:.zero, size: size))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.octi_systemFont(ofSize: size.height * 13.f/37.f), //constant from zeplin, font size 13 is used for an image of 37px tall
            NSAttributedString.Key.foregroundColor: UIColor(sketch:(43,58,63))
        ]
        let text = initials.uppercased()
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        var boundingRect = attributedString.boundingRect(with: size, options: [], context: nil)
        boundingRect.center = CGPoint(x: size.width / 2, y: size.height / 2)
        attributedString.draw(in: boundingRect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
}

extension UIImageView {
    
    func setImage(url: URL?, placeholderInitials: String, size: CGSize, options: SDWebImageOptions = []) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = UIImage.createWithInitials(initials: placeholderInitials, size: size) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        
        if let url = url {
            self.sd_setImage(with: url, placeholderImage: nil, options: options)
        }
    }


}


extension UIImage {
    
  /** 
    Converts the image into an array of RGBA bytes.
   */
  @nonobjc public func toByteArray() -> [UInt8] {
    let width = Int(size.width)
    let height = Int(size.height)
    var bytes = [UInt8](repeating: 0, count: width * height * 4)

    bytes.withUnsafeMutableBytes { ptr in
      if let context = CGContext(
                    data: ptr.baseAddress,
                    width: width,
                    height: height,
                    bitsPerComponent: 8,
                    bytesPerRow: width * 4,
                    space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {

        if let image = self.cgImage {
          let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
          context.draw(image, in: rect)
        }
      }
    }
    return bytes
  }

  /**
    Creates a new UIImage from an array of RGBA bytes.
   */
  @nonobjc public class func fromByteArray(_ bytes: UnsafeMutableRawPointer,
                                           width: Int,
                                           height: Int) -> UIImage {

    if let context = CGContext(data: bytes, width: width, height: height,
                               bitsPerComponent: 8, bytesPerRow: width * 4,
                               space: CGColorSpaceCreateDeviceRGB(),
                               bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
       let cgImage = context.makeImage() {
      return UIImage(cgImage: cgImage, scale: 0, orientation: .up)
    } else {
      return UIImage()
    }
  }
    
}








extension UIImage {
    
    func cropAlpha() -> UIImage {        
        guard let cgImage = self.cgImage ?? UIImage.convertCIImageToCGImage(inputImage: self.ciImage) else {
            return self
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel:Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo),
            let ptr = context.data?.assumingMemoryBound(to: UInt8.self) else {
                return self
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        
        for x in 1 ..< width {
            for y in 1 ..< height {
                
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                let a = CGFloat(ptr[i + 3]) / 255.0
                
                
                if(a>0.01) {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y};
                    if (y > maxY) { maxY = y};
                }
            }
        }
        
        let rect = CGRect(x: CGFloat(minX),y: CGFloat(minY), width: CGFloat(maxX-minX), height: CGFloat(maxY-minY))
        let imageScale:CGFloat = self.scale
        let croppedImage =  cgImage.cropping(to: rect)!
        let ret = UIImage(cgImage: croppedImage, scale: imageScale, orientation: self.imageOrientation)
        
        return ret;
    }
    
    static func convertCIImageToCGImage(inputImage: CIImage?) -> CGImage? {
        guard let inputImage = inputImage else { return nil }
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        return nil
    }
    
}




