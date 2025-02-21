import SwiftUI
import CoreGraphics

class SoftwareRenderer: ObservableObject {
    let width: Int
    let height: Int
    @Published private var pixelData: [UInt32]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.pixelData = Array(repeating: 0xFF000000, count: width * height) // Black background
    }

    func clear(color: UInt32) {
        pixelData = Array(repeating: color, count: width * height)
    }

    func putPixel(x: Int, y: Int, color: UInt32) {
        guard x >= 0, y >= 0, x < width, y < height else { return }
        pixelData[y * width + x] = color
    }

    func renderFrame() -> CGImage? {
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let bytesPerRow = width * 4

        var data = pixelData
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        guard let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * 4)) else { return nil }

        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        ) else { return nil }

        return cgImage
    }

    func startRendering() {
        clear(color: 0xFF202020) // Dark gray background
    }

}

