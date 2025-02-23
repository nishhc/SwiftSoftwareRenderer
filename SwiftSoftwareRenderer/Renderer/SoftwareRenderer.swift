import SwiftUI
import CoreGraphics

public class SoftwareRenderer: ObservableObject {
    let width: Int
    let height: Int
    private var pixelData: [UInt32]

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
    
    func drawLine(x1: Int, y1: Int, x2: Int, y2: Int, color: UInt32) {
        var x1 = x1, y1 = y1, x2 = x2, y2 = y2
        let dx = abs(x2 - x1)
        let dy = -abs(y2 - y1)
        let sx = x1 < x2 ? 1 : -1
        let sy = y1 < y2 ? 1 : -1
        var err = dx + dy
        
        while true {
            putPixel(x: x1, y: y1, color: color)
            if x1 == x2 && y1 == y2 { break }
            let e2 = 2 * err
            if e2 >= dy {
                err += dy
                x1 += sx
            }
            if e2 <= dx {
                err += dx
                y1 += sy
            }
        }
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
        clear(color: 0xFF202020) // Dark
    }
    
    func fillRectangle(x: Int, y: Int, width: Int, height: Int, color: UInt32) {
        // Draw the top and bottom sides
        drawLine(x1: x, y1: y, x2: x + width - 1, y2: y, color: color)
        drawLine(x1: x, y1: y + height - 1, x2: x + width - 1, y2: y + height - 1, color: color)
        
        // Draw the left and right sides
        drawLine(x1: x, y1: y, x2: x, y2: y + height - 1, color: color)
        drawLine(x1: x + width - 1, y1: y, x2: x + width - 1, y2: y + height - 1, color: color)
    }


}

