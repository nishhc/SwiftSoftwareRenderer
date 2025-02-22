import AppKit

class MapHandler {
    
    private var winHeight : Int;
    private var winLength : Int;
    private var renderer : SoftwareRenderer
    
    init(winHeight: Int, winLength: Int, renderer: SoftwareRenderer) {
        self.winHeight = winHeight
        self.winLength = winLength
        self.renderer = renderer
    }
    
    var map : [[Int]] = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,1,1,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,1,1,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1],
                         [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                         [1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1],
                         [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
                         [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    public func draw2DMap() {
        let columns : Int = map[0].count
        let rows : Int = map.count

        let wallLength = Int(ceil(Double(winHeight) / Double(columns)))
        let wallWidth = Int(ceil(Double(winLength) / Double(rows)))

        var cy : Int = 0
        for cr in 0..<rows {
            var cx : Int = 0
            for cc in 0..<columns{
                if map[cr][cc] == 1 {
                    renderer.drawLine(x1: cx, y1: cy, x2: cx+wallLength, y2: cy, color: 0xFFFFFFFF)
                    renderer.drawLine(x1: cx, y1: cy+wallWidth, x2: cx+wallLength, y2: cy+wallWidth, color: 0xFFFFFFFF)
                    renderer.drawLine(x1: cx, y1: cy, x2: cx, y2: cy+wallWidth, color: 0xFFFFFFFF)
                    renderer.drawLine(x1: cx+wallLength, y1: cy, x2: cx+wallLength, y2: cy+wallWidth, color: 0xFFFFFFFF)
                }
                cx += wallLength
            }
            cy += wallWidth
        }
    }
    
    private func fillRectangle(x: Int, y: Int, width: Int, height: Int, color: UInt32) {
        for dy in 0..<height {
            for dx in 0..<width {
                renderer.putPixel(x: x + dx, y: y + dy, color: color)
            }
        }
    }
}



