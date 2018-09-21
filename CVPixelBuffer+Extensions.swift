
import Metal
import CoreVideo
import MetalPerformanceShadersProxy
import CoreImage

 extension CVPixelBuffer {
    
    
    /// Returns an optional `CVMetalTexture` from this `CVPixelBuffer`.
    ///
    /// - Parameters:
    ///   - usingPixelFormat: The MTLPixelFormat to use.
    ///   - planeIndex: The plane index to use for the new texture.
    /// - Returns: A new CVMetalTexture from this pixel buffer - nil if something went wrong with conversion.
    public func toCVMetalTexture(pixelFormat: MTLPixelFormat, planeIndex: Int) -> CVMetalTexture? {
        let width = CVPixelBufferGetWidthOfPlane(self, planeIndex)
        let height = CVPixelBufferGetHeightOfPlane(self, planeIndex)
        
        var texture: CVMetalTexture? = nil
        let status = CVMetalTextureCacheCreateTextureFromImage(nil, GPUManager.sharedInstance.textureCache, self, nil, pixelFormat, width, height, planeIndex, &texture)
        
        if status != kCVReturnSuccess {
            texture = nil
        }
        
        return texture
    }
    
    /// Creates an empty pixel buffer.
    ///
    /// - Parameter size: The dimensions you would like the pixel buffer to be.
    /// - Returns: The newly created empty pixel buffer - nil if there was an issue with creation.
    public static func createEmptyPixelBuffer(size: CGSize) -> CVPixelBuffer? {
        var empty: CFDictionary = CFDictionaryCreate(kCFAllocatorDefault, nil, nil, 0, nil, nil)
        let attributes = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, nil, nil)
        var iOSurfacePropertiesKey = kCVPixelBufferIOSurfacePropertiesKey
        
        withUnsafePointer(to: &iOSurfacePropertiesKey) { unsafePointer in
            CFDictionarySetValue(attributes, unsafePointer, &empty)
        }
        
        var pixelBuffer: CVPixelBuffer? = nil
        
        _ = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width), Int(size.height), kCVPixelFormatType_32BGRA, attributes, &pixelBuffer)
        
        return pixelBuffer
    }

    
    /// Returns an optional `MTLTexture` backed by this `CVPixelBuffer`.
    ///
    /// - Parameters:
    ///   - textureCache: The CVMetalTextureCache to use for this conversion (Note: You can probably just use `GPUManager.sharedInstance.textureCache`.
    ///   - pixelFormat: The `MTLPixelFormat` to use for the new MTLTexture. Defaults to `.bgra8Unorm`.
    /// - Returns: The new `MTLTexture` (which is backed by the `CVPixelBuffer`) - nil if there were any issues with the conversion.
    public func toMTLTexture(textureCache: CVMetalTextureCache, pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        
        if CVPixelBufferGetPixelFormatType(self) == kCVPixelFormatType_32ARGB {
            return self.to32ARGBPixelBufferToMTLTexture(pixelFormat: pixelFormat)
        }
        
        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        
        var texture: CVMetalTexture?

        CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                  textureCache,
                                                  self,
                                                  nil,
                                                  pixelFormat,
                                                  width,
                                                  height,
                                                  0,
                                                  &texture)
        
        if let texture = texture {
            return CVMetalTextureGetTexture(texture)
        }
        
        return nil
    }
    
    /// Fought pixel formats for a while, decided to let Core Image handle it...
    ///
    /// - Parameter imageBuffer: the image buffer to convert
    public func to32ARGBPixelBufferToMTLTexture(pixelFormat: MTLPixelFormat = .bgra8Unorm) -> MTLTexture? {
        let ciImage = CIImage(cvImageBuffer: self)
        let ciContext = CIContext(mtlDevice: GPUManager.sharedInstance.device)
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat,
                                                                  width: CVPixelBufferGetWidth(self),
                                                                  height:  CVPixelBufferGetHeight(self),
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite]
        guard let texture = GPUManager.sharedInstance.device.makeTexture(descriptor: descriptor),
            let commandQueue = GPUManager.sharedInstance.device.makeCommandQueue(),
            let commandBuffer = commandQueue.makeCommandBuffer() else { return nil }
        let flippedImage = ciImage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        ciContext.render(flippedImage, to: texture, commandBuffer: commandBuffer, bounds: flippedImage.extent, colorSpace: CGColorSpaceCreateDeviceRGB())
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        return texture
    }
    
    /// Returns the name of this `CVPixelBuffer`'s pixel format.
    func pixelFormatName() -> String {
        let p = CVPixelBufferGetPixelFormatType(self)
        switch p {
        case kCVPixelFormatType_1Monochrome:                   return "kCVPixelFormatType_1Monochrome"
        case kCVPixelFormatType_2Indexed:                      return "kCVPixelFormatType_2Indexed"
        case kCVPixelFormatType_4Indexed:                      return "kCVPixelFormatType_4Indexed"
        case kCVPixelFormatType_8Indexed:                      return "kCVPixelFormatType_8Indexed"
        case kCVPixelFormatType_1IndexedGray_WhiteIsZero:      return "kCVPixelFormatType_1IndexedGray_WhiteIsZero"
        case kCVPixelFormatType_2IndexedGray_WhiteIsZero:      return "kCVPixelFormatType_2IndexedGray_WhiteIsZero"
        case kCVPixelFormatType_4IndexedGray_WhiteIsZero:      return "kCVPixelFormatType_4IndexedGray_WhiteIsZero"
        case kCVPixelFormatType_8IndexedGray_WhiteIsZero:      return "kCVPixelFormatType_8IndexedGray_WhiteIsZero"
        case kCVPixelFormatType_16BE555:                       return "kCVPixelFormatType_16BE555"
        case kCVPixelFormatType_16LE555:                       return "kCVPixelFormatType_16LE555"
        case kCVPixelFormatType_16LE5551:                      return "kCVPixelFormatType_16LE5551"
        case kCVPixelFormatType_16BE565:                       return "kCVPixelFormatType_16BE565"
        case kCVPixelFormatType_16LE565:                       return "kCVPixelFormatType_16LE565"
        case kCVPixelFormatType_24RGB:                         return "kCVPixelFormatType_24RGB"
        case kCVPixelFormatType_24BGR:                         return "kCVPixelFormatType_24BGR"
        case kCVPixelFormatType_32ARGB:                        return "kCVPixelFormatType_32ARGB"
        case kCVPixelFormatType_32BGRA:                        return "kCVPixelFormatType_32BGRA"
        case kCVPixelFormatType_32ABGR:                        return "kCVPixelFormatType_32ABGR"
        case kCVPixelFormatType_32RGBA:                        return "kCVPixelFormatType_32RGBA"
        case kCVPixelFormatType_64ARGB:                        return "kCVPixelFormatType_64ARGB"
        case kCVPixelFormatType_48RGB:                         return "kCVPixelFormatType_48RGB"
        case kCVPixelFormatType_32AlphaGray:                   return "kCVPixelFormatType_32AlphaGray"
        case kCVPixelFormatType_16Gray:                        return "kCVPixelFormatType_16Gray"
        case kCVPixelFormatType_30RGB:                         return "kCVPixelFormatType_30RGB"
        case kCVPixelFormatType_422YpCbCr8:                    return "kCVPixelFormatType_422YpCbCr8"
        case kCVPixelFormatType_4444YpCbCrA8:                  return "kCVPixelFormatType_4444YpCbCrA8"
        case kCVPixelFormatType_4444YpCbCrA8R:                 return "kCVPixelFormatType_4444YpCbCrA8R"
        case kCVPixelFormatType_4444AYpCbCr8:                  return "kCVPixelFormatType_4444AYpCbCr8"
        case kCVPixelFormatType_4444AYpCbCr16:                 return "kCVPixelFormatType_4444AYpCbCr16"
        case kCVPixelFormatType_444YpCbCr8:                    return "kCVPixelFormatType_444YpCbCr8"
        case kCVPixelFormatType_422YpCbCr16:                   return "kCVPixelFormatType_422YpCbCr16"
        case kCVPixelFormatType_422YpCbCr10:                   return "kCVPixelFormatType_422YpCbCr10"
        case kCVPixelFormatType_444YpCbCr10:                   return "kCVPixelFormatType_444YpCbCr10"
        case kCVPixelFormatType_420YpCbCr8Planar:              return "kCVPixelFormatType_420YpCbCr8Planar"
        case kCVPixelFormatType_420YpCbCr8PlanarFullRange:     return "kCVPixelFormatType_420YpCbCr8PlanarFullRange"
        case kCVPixelFormatType_422YpCbCr_4A_8BiPlanar:        return "kCVPixelFormatType_422YpCbCr_4A_8BiPlanar"
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:  return "kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange"
        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:   return "kCVPixelFormatType_420YpCbCr8BiPlanarFullRange"
        case kCVPixelFormatType_422YpCbCr8_yuvs:               return "kCVPixelFormatType_422YpCbCr8_yuvs"
        case kCVPixelFormatType_422YpCbCr8FullRange:           return "kCVPixelFormatType_422YpCbCr8FullRange"
        case kCVPixelFormatType_OneComponent8:                 return "kCVPixelFormatType_OneComponent8"
        case kCVPixelFormatType_TwoComponent8:                 return "kCVPixelFormatType_TwoComponent8"
        case kCVPixelFormatType_30RGBLEPackedWideGamut:        return "kCVPixelFormatType_30RGBLEPackedWideGamut"
        case kCVPixelFormatType_OneComponent16Half:            return "kCVPixelFormatType_OneComponent16Half"
        case kCVPixelFormatType_OneComponent32Float:           return "kCVPixelFormatType_OneComponent32Float"
        case kCVPixelFormatType_TwoComponent16Half:            return "kCVPixelFormatType_TwoComponent16Half"
        case kCVPixelFormatType_TwoComponent32Float:           return "kCVPixelFormatType_TwoComponent32Float"
        case kCVPixelFormatType_64RGBAHalf:                    return "kCVPixelFormatType_64RGBAHalf"
        case kCVPixelFormatType_128RGBAFloat:                  return "kCVPixelFormatType_128RGBAFloat"
        case kCVPixelFormatType_14Bayer_GRBG:                  return "kCVPixelFormatType_14Bayer_GRBG"
        case kCVPixelFormatType_14Bayer_RGGB:                  return "kCVPixelFormatType_14Bayer_RGGB"
        case kCVPixelFormatType_14Bayer_BGGR:                  return "kCVPixelFormatType_14Bayer_BGGR"
        case kCVPixelFormatType_14Bayer_GBRG:                  return "kCVPixelFormatType_14Bayer_GBRG"
        default: return "UNKNOWN"
        }
    }
    
 }

