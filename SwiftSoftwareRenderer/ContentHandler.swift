import SwiftUI
import AppKit

private var renderer = SoftwareRenderer(width: ContentView.xres, height: ContentView.yres)
private var mapHandler = MapHandler(winHeight: ContentView.xres, winLength: ContentView.yres, renderer: renderer, map :
[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
 [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
 [1,0,1,1,0,0,1,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,1,0,0,0,0,1,1,0,0,1],
 [1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1],
 [1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1],
 [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
 [1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1],
 [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
 [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]])

class ContentHandler: ObservableObject {
    @Published var image: Image = Image("")
    
    private var player = Player(x: CGFloat(ContentView.xres) / 2,
                                y: CGFloat(ContentView.yres) / 2,
                                angle: 0,
                                renderer: renderer)

    
   
    
    var upPressed = false
    var downPressed = false
    var leftPressed = false
    var rightPressed = false
    
    let moveSpeed: CGFloat = 120
    let turnSpeed: CGFloat = 3.0
    
    private var timer: Timer?
    private var lastTime: CFTimeInterval = 0
    
    init() {
        updateImage()
    }
    
    func start() {
        lastTime = CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            let currentTime = CFAbsoluteTimeGetCurrent()
            let deltaTime = currentTime - self.lastTime
            self.lastTime = currentTime
            
            if self.upPressed {
                self.player.move(distance: self.moveSpeed * CGFloat(deltaTime))
            }
            if self.downPressed {
                self.player.move(distance: -self.moveSpeed * CGFloat(deltaTime))
            }
            if self.leftPressed {
                self.player.turn(delta: -self.turnSpeed * CGFloat(deltaTime))
            }
            if self.rightPressed {
                self.player.turn(delta: self.turnSpeed * CGFloat(deltaTime))
            }
            
            self.updateScene()
        }
    }
    
    func updateScene() {
        renderer.clear(color: 0xFF202020)
        mapHandler.draw2DMap()
        player.draw()
        //let fov: CGFloat = 60 * (.pi / 180)
        //  raycaster.castFOV(from: player.position, direction: player.angle, fov: fov, rayCount: 100)
        updateImage()
        
    }
    
    private func updateImage() {
        if let cgImage = renderer.renderFrame() {
            DispatchQueue.main.async {
                self.image = Image(cgImage, scale: 1.0, label: Text("Rendered Image"))
                    .resizable()
            }
        }
    }
    
    func keyDown(event: NSEvent) {
        switch event.keyCode {
        case 126: // up
            upPressed = true
        case 125: // down
            downPressed = true
        case 123: // left
            leftPressed = true
        case 124: // right
            rightPressed = true
        default:
            break
        }
    }
    
    func keyUp(event: NSEvent) {
        switch event.keyCode {
        case 126: // up
            upPressed = false
        case 125: // down
            downPressed = false
        case 123: // left
            leftPressed = false
        case 124: // right
            rightPressed = false
        default:
            break
        }
    }
}
