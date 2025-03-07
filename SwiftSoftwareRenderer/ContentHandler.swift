import SwiftUI
import AppKit

private var renderer = SoftwareRenderer(width: ContentView.xres, height: ContentView.yres)
private var mapHandler = MapHandler(winHeight: ContentView.xres, winLength: ContentView.yres, renderer: renderer, mapa :
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

private var raycaster = Raycaster(renderer: renderer, maphandler: mapHandler)

class ContentHandler: ObservableObject {
    @Published var image: Image = Image("")
    
    private var player = Player(x: CGFloat(ContentView.xres) / 2,
                                y: CGFloat(ContentView.yres) / 2,
                                angle: 0,
                                renderer: renderer, handler: mapHandler)

     var is3DProjectionEnabled = true
     var is2DProjectionEnabled = false
     var is2DRaycastEnabled = false
   
    
    var upPressed = false
    var downPressed = false
    var leftPressed = false
    var rightPressed = false
    
    let moveSpeed: CGFloat = 80
    let turnSpeed: CGFloat = 3.0
    
    private var timer: Timer?
    private var lastTime: CFTimeInterval = 0
    
    init() {
        updateImage()
    }
    
    func start() {
        lastTime = CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0/120.0, repeats: true) { [weak self] timer in
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
        
        if (is3DProjectionEnabled) {
            print("Enabled 3d")
            raycaster.castRay(position: mapHandler.returnGridPos(position: player.position), player: player, rayMode: false)
        }
        if (is2DRaycastEnabled) {
            raycaster.castRay(position: mapHandler.returnGridPos(position: player.position), player: player, rayMode : true)
        }
        if (is2DProjectionEnabled) {
            mapHandler.draw2DMap()
            player.draw()
        }
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
