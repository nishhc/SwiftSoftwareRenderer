import CoreGraphics
import SwiftUI

class Raycaster {
    
    // raycasting vars
    private let FOV: Double = .pi / 3.0
    private let hFOV: Double = (.pi / 3.0) / 2.0
    private let NUM_RAYS: Int = Int(ContentView.xres / 2)
    private let hNUM_RAYS: Int = Int(ContentView.xres / 4)
    private let DELTA_ANGLE: Double = (Double.pi / 3.0) / Double(ContentView.xres / 2)
    private let MAX_DEPTH: Int = 20
    public var depth = 0.0
    private var SCREEN_DIST : CGFloat
    private var SCALE : Int
    // 3d projection vars
    
    private let half_width = ContentView.xres / 2
    private let half_height = ContentView.yres / 2
    
    private var renderer : SoftwareRenderer
    private var map : MapHandler
    
    init(renderer : SoftwareRenderer, maphandler : MapHandler) {
        self.renderer = renderer
        self.map = maphandler
        self.SCREEN_DIST = (CGFloat(half_width) / tan(hFOV))
        self.SCALE = ContentView.xres / NUM_RAYS
    }
    
    public func castRay(position: CGPoint, player : Player) {
        let tilePos = map.returnTilePos(position: position)
        var ray_angle = player.angle - hFOV + 0.0001
        
        for ray in 0..<NUM_RAYS {
            let sin_a = sin(ray_angle)
            let cos_a = cos(ray_angle)
            
            var y_hor = tilePos.y + 1
            var _dy = 1.0
            if (sin_a < 0) {
                y_hor = tilePos.y - 1e-6
                _dy = -1
            }
            
            var depth_hor : CGFloat = (y_hor - position.y) / sin_a
            var x_hor = position.x + depth_hor * cos_a
            
            var delta_depth = _dy / sin_a
            var _dx = delta_depth * cos_a
            
            for _ in 0..<MAX_DEPTH {
                let tile_point : (Int, Int) = (Int(x_hor), Int(y_hor))
                let arrCheck : [Int] = map.mapGeoPoints[tile_point.1] ?? []
                if (arrCheck.contains(tile_point.0)) {
                    break
                }
                
                x_hor += _dx
                y_hor += _dy
                depth_hor += delta_depth
                
                
            }
            
            
            var x_vert = tilePos.x + 1
             _dx = 1.0
            if (cos_a < 0) {
                x_vert = tilePos.x - 1e-6
                _dx = -1
            }
            
            var depth_vert : CGFloat = (x_vert - position.x) / cos_a
            var y_vert = position.y + depth_vert * sin_a
            
             delta_depth = _dx / cos_a
             _dy = delta_depth * sin_a
            
        
            for _ in 0..<MAX_DEPTH {
                let tile_point : (Int, Int) = (Int(x_vert), Int(y_vert))
    
                let arrCheck : [Int] = map.mapGeoPoints[tile_point.1]  ?? []
                if (arrCheck.contains(tile_point.0)) {
                    break
                }
                
                x_vert += _dx
                y_vert += _dy
                depth_vert += delta_depth
                
                
            }
            
        
            if (depth_vert < depth_hor) {
                self.depth = depth_vert
            } else
            {
                self.depth = depth_hor
            }
         
            // debug raylines
            //renderer.drawLine(x1: Int(player.position.x), y1: Int(player.position.y), x2: Int(player.position.x + CGFloat(40.0 * cos_a * depth)), y2: Int(player.position.y + CGFloat(40.0 * sin_a * depth)), color: 0xFF0000FF)
            depth *= cos(player.angle - ray_angle)
            
            let proj_height = SCREEN_DIST / (depth + 0.0001)
            renderer.fillRectangle(x: ray * SCALE, y: half_height - Int(proj_height) / 2,  width: SCALE, height: Int(proj_height), color: 0xFFFFFFFF)
            ray_angle += CGFloat(DELTA_ANGLE)
            
        }
        
        func calculateRBValue(depth: Double) -> UInt32 {
            let result = (255.0 / (1.0 + pow(depth, pow(5, 0.00002)))) * 3.0
            return UInt32(max(0, min(result, Double(UInt32.max))))
        }
        
        
        
    }

}
