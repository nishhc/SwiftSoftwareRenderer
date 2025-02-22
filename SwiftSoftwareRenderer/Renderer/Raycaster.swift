import CoreGraphics
import SwiftUI

class Raycaster {
    let renderer: SoftwareRenderer
    let map: [[Int]]
    let columns: Int
    let rows: Int
    let cellWidth: Int
    let cellHeight: Int

    init(renderer: SoftwareRenderer, map: [[Int]], winHeight: Int, winLength: Int) {
        self.renderer = renderer
        self.map = map
        self.columns = map[0].count
        self.rows = map.count
        self.cellWidth = Int(ceil(Double(winHeight) / Double(columns)))
        self.cellHeight = Int(ceil(Double(winLength) / Double(rows)))
    }

    func castRay(from position: CGPoint, angle: CGFloat, maxDistance: CGFloat = 1000) {
        var currentDistance: CGFloat = 0
        let step: CGFloat = 1
        var hitPoint = position

        while currentDistance < maxDistance {
            currentDistance += step
            let x = position.x + cos(angle) * currentDistance
            let y = position.y + sin(angle) * currentDistance
            hitPoint = CGPoint(x: x, y: y)
            
            let col = Int(x) / cellWidth
            let row = Int(y) / cellHeight
            
            if row < 0 || row >= rows || col < 0 || col >= columns {
                break
            }
            
            if map[row][col] == 1 {
                break
            }
        }
        
        let color: UInt32 = 0xFFFF0000
        renderer.drawLine(x1: Int(position.x), y1: Int(position.y),
                          x2: Int(hitPoint.x), y2: Int(hitPoint.y),
                          color: color)
    }
    
    func castFOV(from position: CGPoint, direction: CGFloat, fov: CGFloat, rayCount: Int) {
        let startAngle = direction - fov / 2
        let angleStep = fov / CGFloat(rayCount - 1)
        for i in 0..<rayCount {
            let rayAngle = startAngle + angleStep * CGFloat(i)
            castRay(from: position, angle: rayAngle)
        }
    }
}
