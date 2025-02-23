import AppKit

class MapHandler {
    
    private var winHeight : Int;
    private var winLength : Int;
    private var renderer : SoftwareRenderer
    private var map : [[Int]]
    private var columns : Int
    private var rows : Int
    private var wallLength : Int
    private var wallWidth : Int
    
    init(winHeight: Int, winLength: Int, renderer: SoftwareRenderer, map : [[Int]] ) {
        self.winHeight = winHeight
        self.winLength = winLength
        self.renderer = renderer
        self.map = map
        self.columns = map[0].count
        self.rows = map.count
        self.wallLength = Int(ceil(Double(winHeight) / Double(columns)))
        self.wallWidth = Int(ceil(Double(winLength) / Double(rows)))
    }
    
    
    
    public func draw2DMap() {
       

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
    
    
    public func returnTilePos(position : CGPoint) -> CGPoint {
        let gx : Int = Int(position.x)
        let gy : Int = Int(position.y)
        
        return CGPoint(x: Int(gx / wallLength) * wallLength, y: Int(gy / wallWidth) * wallWidth)
        
    }
     
    
    private func fillRectangle(x: Int, y: Int, width: Int, height: Int, color: UInt32) {
        for dy in 0..<height {
            for dx in 0..<width {
                renderer.putPixel(x: x + dx, y: y + dy, color: color)
            }
        }
    }
}



