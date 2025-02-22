import SwiftUI

private var renderer = SoftwareRenderer(width: 320, height: 240)
private var mapHandler = MapHandler(winHeight: 320, winLength: 240, renderer: renderer)

class ContentHandler {
    
    @State private var zoomScale: CGFloat = 1.0
    
    init() {
    }
    
    func start () -> Image {
            if let cgImage = renderer.renderFrame() {
                return Image(cgImage, scale: 1.0, label: Text("Rendered Image"))                    .interpolation(.none)  //
                    .resizable()
            } else {
                return Image("")
            }
    }
    
    func place () {
        renderer.clear(color: 0x00000000)
        mapHandler.draw2DMap()
    }
    
    
}
