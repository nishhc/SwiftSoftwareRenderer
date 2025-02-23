import SwiftUI
import AppKit

struct ContentView: View {
    static let xres: Int = 240
    static let yres: Int = 150
    
    @StateObject private var ch = ContentHandler()

    var body: some View {
        VStack {
            ch.image.interpolation(.none)
        }
        .frame(width: CGFloat(640), height: CGFloat(400))
        .aspectRatio(contentMode: .fit)
        .clipped()
        .border(Color.white, width: 1)
        .onAppear {
            ch.start()
            
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                ch.keyDown(event: event)
                return event
            }
            NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
                ch.keyUp(event: event)
                return event
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
