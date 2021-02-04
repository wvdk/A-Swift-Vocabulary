import MetalKit

public class MetalCanvas: MTKView, MTKViewDelegate {
    
    var commandQueue: MTLCommandQueue?
    var cps: MTLComputePipelineState?
    
    public required init(frame: CGRect, shader: String) {
        super.init(frame: frame, device: MTLCreateSystemDefaultDevice()!)
        commandQueue = device!.makeCommandQueue()
        clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1)
        colorPixelFormat = .bgra8Unorm
        let library = try! device!.makeLibrary(source: shader, options: nil)
        let function = library.makeFunction(name:"k")!
        cps = try! device!.makeComputePipelineState(function: function)
        delegate = self
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    public func draw(in view: MTKView) {
        if let drawable = view.currentDrawable,
           let commandBuffer = commandQueue!.makeCommandBuffer(),
           let commandEncoder = commandBuffer.makeComputeCommandEncoder() {
            commandEncoder.setComputePipelineState(cps!)
            commandEncoder.setTexture(drawable.texture, index: 0)
            let groups = MTLSize(width: Int(view.frame.width)/4, height: Int(view.frame.height)/4, depth: 1)
            let threads = MTLSize(width: 8, height: 8,depth: 1)
            commandEncoder.dispatchThreadgroups(groups,threadsPerThreadgroup: threads)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
}

