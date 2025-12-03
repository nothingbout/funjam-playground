import Foundation

@main
struct App {
    static func main() {
#if os(WASI)
        var fpsSecondsAccumulated: Double = 0.0
        var fpsFrameCount: Int64 = 0

        let fpsObject = RenderObject(
            transform: Transform2D(
                position: Vector2(80.0, 30.0),
                rotation: .degrees(00.0),
                scale: Vector2(1.0, 1.0),
                depth: 0.0,
            ),
            color: Color("#777777")!,
            data: .text(text: "FPS: ??", fontSize: 12.0)
        )

        let asteroidObject = RenderObject(
            transform: Transform2D(
                position: Vector2(300.0, 200.0),
                rotation: .degrees(00.0),
                scale: Vector2(1.0, 1.0),
                depth: 0.0,
            ),
            color: Color("#777777")!,
            data: .text(text: """
                  ###
                 #####
                #######
                 #####
                  ### 
                """, fontSize: 12.0)
        )

        let platform = WebPlatform()
        var inputState = InputState()
        platform.startAnimationUpdates { frameTime in
            fpsSecondsAccumulated += frameTime.deltaSeconds
            fpsFrameCount += 1
            if fpsSecondsAccumulated >= 0.2 {
                let fps = Double(fpsFrameCount) / fpsSecondsAccumulated
                fpsSecondsAccumulated = 0.0
                fpsFrameCount = 0
                fpsObject.data = .text(text: "FPS: \(Int(round(fps)))", fontSize: 12.0)
            }

            inputState.startFrame(frameTime)
            let events = platform.takeEvents()
            for event in events {
                inputState.update(with: event)
                switch event {
                case .resize:
                    // print("resizeEvent: \(platform.renderer.dimensions)")
                    break
                case .keyboard(let payload):
                    // print("keyboardEvent \(payload)")
                    break
                case .mouse(let payload):
                    // print("mouseEvent \(payload), positionInRenderer: \(platform.renderer.position(of: payload))")
                    break
                }
            }

            let backingSize = platform.renderer.backingSize
            let desiredHeight = 480.0
            platform.renderer.renderScale = backingSize.y / desiredHeight
            let viewSize = platform.renderer.operationalSize

            fpsObject.transform.position = Vector2(viewSize.x - 100.0, 30.0)

            var turnDirection: Int = 0
            if inputState.isKeyboardKeyPressed(.arrowLeft) {
                turnDirection = -1
            }
            if inputState.isKeyboardKeyPressed(.arrowRight) {
                turnDirection = 1
            }
            if turnDirection != 0 {
                let rotationAmount: Angle = .degrees(90.0 * frameTime.deltaSeconds * Double(turnDirection))
                asteroidObject.transform.rotation += rotationAmount
            }

            platform.renderer.drawObject(fpsObject)
            platform.renderer.drawObject(asteroidObject)
        }
#else
#endif
    }
}
