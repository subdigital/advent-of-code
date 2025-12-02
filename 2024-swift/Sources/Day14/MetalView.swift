//
//  MetalView.swift
//  AOCDay14
//
//  Created by Ben Scheirman on 12/14/24.
//

import AppKit
import MetalKit
import SwiftUI
import Carbon.HIToolbox

class UpdateContext {
    fileprivate(set) var dt: CFTimeInterval = 0
    fileprivate(set) var keysDown: Set<UInt16> = []
    fileprivate(set) var keysDownLastFrame: Set<UInt16> = []

    func justPressed(key: UInt16) -> Bool {
        !keysDownLastFrame.contains(key) && keysDown.contains(key)
    }
}

class MetalView: MTKView {
    private var commandQueue: MTLCommandQueue!
    private var computePipeline: MTLComputePipelineState!
    private var texture: MTLTexture!
    private var pipelineState: MTLRenderPipelineState!
    private var pixelData: [Pixel]
    private var lastFrameTime: CFTimeInterval = 0
    private var textureSize: TextureSize

    private var updateContext = UpdateContext()

    var updateBlock: (UpdateContext) -> Void = { _ in }
    var renderBlock: (inout [Pixel]) -> Void = { _ in }


    required init(coder: NSCoder) {
        fatalError()
    }

    init(textureSize: TextureSize = .init(width: 100, height: 100)) {
        let device = MTLCreateSystemDefaultDevice()!
        self.textureSize = textureSize
        self.pixelData = Array(repeating: .black, count: textureSize.width * textureSize.height)

        super.init(frame: CGRectMake(0, 0, 800, 800), device: device)

        setupMetal(device)
        createTexture(device)
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        window?.makeFirstResponder(self)
    }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)

        if event.keyCode == kVK_Escape {
            NSApplication.shared.terminate(nil)
        } else {
            updateContext.keysDown.insert(event.keyCode)
        }
    }

    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        updateContext.keysDown.remove(event.keyCode)
    }

    private func setupMetal(_ device: MTLDevice) {
        commandQueue = device.makeCommandQueue()

        // setup pipeline state
        print("Loading shaders from bundle: \(Bundle.module.bundlePath)")
        let shaderURL = Bundle.module.url(forResource: "default", withExtension: "metallib")!
        let library = try! device.makeLibrary(URL: shaderURL)
        let vertexFn = library.makeFunction(name: "vertexShader")
        let fragFn = library.makeFunction(name: "fragmentShader")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFn
        pipelineDescriptor.fragmentFunction = fragFn
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    }

    private func createTexture(_ device: MTLDevice) {
        let textureDesc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba8Unorm,
            width: Int(textureSize.width),
            height: Int(textureSize.height),
            mipmapped: false
        )

        textureDesc.usage = [.shaderRead, .shaderWrite]
        texture = device.makeTexture(descriptor: textureDesc)
    }

    private func generatePixelData() {
        for y in 0..<Int(textureSize.height) {
            for x in 0..<(Int(textureSize.width)) {
                let index = y * Int(textureSize.width) + x
                pixelData[index] = Pixel(r: UInt8(x), g: UInt8(y), b: 0, a: 255)
            }
        }
    }

    private func updateTexture() {
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)

        pixelData.withUnsafeBytes { bufferPtr in
            texture.replace(
                region: region,
                mipmapLevel: 0,
                withBytes: bufferPtr.baseAddress!,
                bytesPerRow: Int(textureSize.width) * MemoryLayout<Pixel>.stride
            )
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let currentDrawable,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDesc = currentRenderPassDescriptor
        else {
            return
        }

        // update
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastFrameTime
        updateContext.dt = deltaTime
        updateBlock(updateContext)

        updateContext.keysDownLastFrame = updateContext.keysDown

        // render
        renderBlock(&pixelData)

        updateTexture()

        // render
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setFragmentTexture(texture, index: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        renderEncoder.endEncoding()

        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}

struct TextureSize {
    let width: Int
    let height: Int
}

struct MetalViewRepresentable: NSViewRepresentable {
    var textureSize: TextureSize
    var update: (UpdateContext) -> Void
    var render: (inout [Pixel]) -> Void

    func makeNSView(context: Context) -> MetalView {
        let metalView = MetalView(textureSize: textureSize)
        metalView.updateBlock = update
        metalView.renderBlock = render
        return metalView
    }

    func updateNSView(_ nsView: MetalView, context: Context) {
        nsView.setNeedsDisplay(nsView.bounds)
    }
}
