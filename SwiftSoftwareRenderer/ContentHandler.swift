import SwiftUI

private var renderer = SoftwareRenderer(width: ContentView.xres, height: ContentView.yres)
private var mapHandler = MapHandler(winHeight: ContentView.xres, winLength: ContentView.yres, renderer: renderer)

class ContentHandler: ObservableObject {
    @Published var image: Image = Image("")

    init() {
        updateImage()
    }
    
    func start() {
        updateImage()
    }
    
    func place() {
        renderer.clear(color: 0x00000000)
        mapHandler.draw2DMap()
        updateImage()
    }
    
    private func updateImage() {
        if let cgImage = renderer.renderFrame() {
            DispatchQueue.main.async {
                self.image = Image(cgImage, scale: 1.0, label: Text("Rendered Image"))
                    .interpolation(.none).resizable()
            }
        }
    }
}
