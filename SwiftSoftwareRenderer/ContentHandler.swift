import SwiftUI

private var renderer = SoftwareRenderer(width: ContentView.xres, height: ContentView.yres)
private var mapHandler = MapHandler(winHeight: ContentView.xres, winLength: ContentView.yres, renderer: renderer)

class ContentHandler {
    
    @State private var zoomScale: CGFloat = 1.0
    
    init() {
    }
    
    func start () -> Image {
            if let cgImage = renderer.renderFrame() {
                return Image(cgImage, scale: 1.0, label: Text("Rendered Image")).interpolation(.none)  //
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
