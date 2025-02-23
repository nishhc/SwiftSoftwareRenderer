import AppKit

class MapHandler {
    
    private var winHeight : Int;
    private var winLength : Int;
    private var renderer : SoftwareRenderer
    private var map : [[Int]]
     var columns : Int
     var rows : Int
     var wallLength : Int
     var wallWidth : Int
    var mapGeoPoints : Dictionary<Int, [Int]>
    
    init(winHeight: Int, winLength: Int, renderer: SoftwareRenderer, mapa : [[Int]] ) {
        self.winHeight = winHeight
        self.winLength = winLength
        self.renderer = renderer
        self.map = mapa
        self.columns = map[0].count
        self.rows = map.count
        self.wallLength = Int(ceil(Double(winHeight) / Double(columns)))
        self.wallWidth = Int(ceil(Double(winLength) / Double(rows)))
        mapGeoPoints = [:]
        getMapGeo(mapa: mapa)

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
        return CGPoint(x: Int(gx), y: Int(gy))
    }
    
    func returnGridPos(position : CGPoint) -> CGPoint {
        return CGPoint(x: position.x / CGFloat(wallLength), y: position.y / CGFloat(wallWidth))
    }
    
    
    public func getMapGeo(mapa : [[Int]]) {
        var geo : Dictionary<Int, [Int]> = [:]
        for i in 0..<rows {
            var xArr : [Int] = []
            for j in 0..<columns {
                if (mapa[i][j] == 1) {
                    xArr.append(j)
                }
            }
            if (xArr.count > 0) {
                geo[i] = xArr
            }
        }
        self.mapGeoPoints = geo
    }
     
    
    private func fillRectangle(x: Int, y: Int, width: Int, height: Int, color: UInt32) {
        for dy in 0..<height {
            for dx in 0..<width {
                renderer.putPixel(x: x + dx, y: y + dy, color: color)
            }
        }
    }
}



