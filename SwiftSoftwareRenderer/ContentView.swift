import SwiftUI

struct ContentView: View {
    static let xres: Int = 640
    static let yres: Int = 400

    @StateObject private var ch = ContentHandler()

    var body: some View {
        VStack {
            ch.image
        }
        .frame(width: CGFloat(ContentView.xres), height: CGFloat(ContentView.yres))
        .aspectRatio(contentMode: .fit)
        .clipped()
        .border(Color.white, width: 1)
        .onAppear {
            ch.start()
            ch.place()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

