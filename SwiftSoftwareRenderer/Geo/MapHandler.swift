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
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
                         [1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1],
                         [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
                         [1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1],
                         [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
                         [1,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1],
                         [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
                         [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    public func draw2DMap() {
        let columns : Int = map[0].count
        let rows : Int = map.count
        /*center pixel fire emoji*/ renderer.putPixel(x: 160, y:120, color: 0xFFFFFFFF)

        let wallLength = Int(ceil(Double(winHeight) / Double(columns)))
        let wallWidth = Int(ceil(Double(winLength) / Double(rows)))

        var cy : Int = 0
        for cr in 0..<rows {
            var cx : Int = 0
            for cc in 0..<columns{
                if map[cr][cc] == 1 {

                    for dry in cy..<(cy+wallWidth) {
                        for drx in cx..<(cx+wallLength)
                        {
                            renderer.putPixel(x: drx, y: dry, color: 0xFFFFFFFF)
                        }
                    }
            
                }
                cx += wallLength
            }
            cy += wallWidth
        }
    }
}
