import SwiftUI


struct ContentView: View {
    
    @State private var zoomScale: CGFloat = 1.0
    private var ch = ContentHandler()
    
    var body: some View {
        VStack {
            ch.start()
        }
        .frame(width:640, height: 480)
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

