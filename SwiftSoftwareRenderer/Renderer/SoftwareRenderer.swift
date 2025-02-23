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
        let startX = max(0, x)
          let startY = max(0, y)
        let endX = min(self.width, x + width)
        let endY = min(self.height, y + height)
          let rowCount = endX - startX

          // Pre-create a row buffer filled with the desired color.
          let rowBuffer = [UInt32](repeating: color, count: rowCount)

          // Use low-level pointer operations to copy the rowBuffer into each row of the rectangle.
          pixelData.withUnsafeMutableBufferPointer { buffer in
              for row in startY..<endY {
                  let startIndex = row * self.width + startX
                  rowBuffer.withUnsafeBufferPointer { src in
                      buffer.baseAddress!.advanced(by: startIndex)
                          .assign(from: src.baseAddress!, count: rowCount)
                  }
              }
          }
    }



}

