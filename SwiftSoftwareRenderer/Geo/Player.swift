import CoreGraphics
import SwiftUI

class Player {
    var position: CGPoint
    var angle: CGFloat
    let renderer: SoftwareRenderer
    let lineLength: CGFloat = 20

    init(x: CGFloat, y: CGFloat, angle: CGFloat, renderer: SoftwareRenderer) {
        self.position = CGPoint(x: x, y: y)
        self.angle = angle
        self.renderer = renderer
    }
    
    func move(distance: CGFloat) {
        position.x += cos(angle) * distance
        position.y += sin(angle) * distance
    }
    
    func turn(delta: CGFloat) {
        angle += delta
    }
    
  
    func draw() {
        let half = lineLength / 2.0
        let tail = CGPoint(x: position.x - cos(angle) * half,
                           y: position.y - sin(angle) * half)
        let tip  = CGPoint(x: position.x + cos(angle) * half,
                           y: position.y + sin(angle) * half)
        let color: UInt32 = 0xFF00FF00  // Green color
        
        renderer.drawLine(x1: Int(tail.x), y1: Int(tail.y),
                          x2: Int(tip.x),  y2: Int(tip.y), color: color)
    }
}
