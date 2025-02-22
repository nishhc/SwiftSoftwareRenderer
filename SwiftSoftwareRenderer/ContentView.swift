import SwiftUI


struct ContentView: View {
    
    static let xres : Int = 640
    static let yres : Int = 400
    
    @State private var zoomScale: CGFloat = 1.0
    private var ch = ContentHandler()
    
    var body: some View {
        VStack {
            ch.start()
        }
        .frame(width:CGFloat(ContentView.xres), height: CGFloat(ContentView.yres))
        .aspectRatio(contentMode: .fit)
        .onAppear {
            ch.place()
        }
        /*
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    
                    zoomScale = round(value)
                }
        )*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

