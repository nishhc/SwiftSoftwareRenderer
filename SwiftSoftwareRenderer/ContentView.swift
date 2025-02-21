import SwiftUI

private var renderer = SoftwareRenderer(width: 640, height: 480)

struct ContentView: View {
    
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            if let cgImage = renderer.renderFrame() {
                Image(cgImage, scale: 1.0, label: Text("Rendered Image"))                    .interpolation(.none)  //
                    .resizable()
                    .scaleEffect(zoomScale)

            } else {
                Text("Failed to render image")
            }
        }
        .onAppear {
            renderer.startRendering()
            drawTestPattern()
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    
                    zoomScale = round(value) 
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


private func drawTestPattern() {
    for x in 200...450 {
        for y in 100...350 {
            renderer.putPixel(x: x, y: y, color: 0xFFFFFFFF)
        }
    }
}
