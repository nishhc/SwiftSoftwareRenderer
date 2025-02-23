import CoreGraphics
import SwiftUI

class Raycaster {
    private var FOV = Double.pi / 3
    private var hHOV = (Double.pi / 3) / 2
    private var NUM_RAYS = Int(ContentView.xres/2)
    private var hNUM_RAYS =  Int(ContentView.xres/4)
    private var DELTA_ANGLE = Int(Double.pi/3) / Int(ContentView.xres/2)
    private var MAX_DEPTH = 20

    func castRay(from position: CGPoint, map: MapHandler) {
        var ox = position.x
        var oy = position.y
        
        
    }

}
