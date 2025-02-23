import CoreGraphics
import SwiftUI

class Player {
    var position: CGPoint
    var angle: CGFloat
    let renderer: SoftwareRenderer
    let handler : MapHandler
    let lineLength: CGFloat = 20 / 640 * CGFloat(ContentView.xres)

    init(x: CGFloat, y: CGFloat, angle: CGFloat, renderer: SoftwareRenderer, handler : MapHandler) {
        self.position = CGPoint(x: x, y: y)
        self.angle = angle
        self.renderer = renderer
        self.handler = handler
    }
    
    func move(distance: CGFloat) {
        let dx = cos(angle) * distance
        let dy = sin(angle) * distance
        checkCol(dx: dx, dy: dy)
    }
    
    func check_wall( xpos : Int,  ypos : Int) -> Bool {
        let arrCheck : [Int] = handler.mapGeoPoints[ypos]  ?? []
        return !arrCheck.contains(xpos)
    }
    
    func checkCol(dx : CGFloat, dy : CGFloat) {
        let playerGridPos : CGPoint = handler.returnGridPos(position: position)
        let dChangeGrid : CGPoint = handler.returnGridPos(position: CGPoint(x: dx, y: dy))
        if (check_wall(xpos: Int(playerGridPos.x + dChangeGrid.x), ypos: Int(playerGridPos.y))) {
            position.x += dx
        }
        
        if (check_wall(xpos: Int(playerGridPos.x), ypos: Int(playerGridPos.y+dChangeGrid.y))) {
            position.y += dy
        }
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
        let head  = CGPoint(x: position.x + cos(angle) * (half/4),
                           y: position.y + sin(angle) * (half/4))
        let color: UInt32 = 0xFF00FF00  // Green color
        
        renderer.drawLine(x1: Int(tail.x), y1: Int(tail.y),
                          x2: Int(tip.x),  y2: Int(tip.y), color: color)
        renderer.drawLine(x1: Int(head.x), y1: Int(head.y),
                          x2: Int(tip.x),  y2: Int(tip.y), color: 0xFF0000FF)
    }
}
