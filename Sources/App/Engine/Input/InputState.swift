import Foundation

fileprivate extension Duration {
    static let infinite = Duration(secondsComponent: Int64.max, attosecondsComponent: Int64.max)
}

public struct InputState {
    public enum PressedState {
        case pressed
        case notPressed
    }

    private struct KeyboardKeyState {
        var pressedState: PressedState
        var changeTime: Duration
    }

    private struct MouseButtonState {
        var pressedState: PressedState
        var changeTime: Duration
    }

    private var _keyboardKeyState: [KeyboardEventPayload.PhysicalKey: KeyboardKeyState] = [:]
    private var _mouseButtonState: [MouseEventPayload.Button: MouseButtonState] = [:]
    private var _mousePosition: Vector2? = nil
    private var _currentFrameTime: FrameTime? = nil

    public init() {
    }

    public mutating func startFrame(_ frameTime: FrameTime) {
        _currentFrameTime = frameTime
    }

    public mutating func update(with event: EngineEvent) {
        let currentTime = _currentFrameTime!.timeSinceStartup
        switch event {
        case .keyboard(let payload):
            if let key = payload.key {
                switch payload.eventType {
                case .keyDown:
                    if !isKeyboardKeyPressed(key) {
                        _keyboardKeyState[key] = KeyboardKeyState(pressedState: .pressed, changeTime: currentTime)
                    }
                case .keyRepeat:
                    break
                case .keyUp:
                    if isKeyboardKeyPressed(key) {
                        _keyboardKeyState[key] = KeyboardKeyState(pressedState: .notPressed, changeTime: currentTime)
                    }
                }
            }
        case .mouse(let payload):
            switch payload.eventType {
            case .buttonDown(let button):
                if !isMouseButtonPressed(button) {
                    _mouseButtonState[button] = MouseButtonState(pressedState: .pressed, changeTime: currentTime)
                }
            case .buttonUp(let button):
                if isMouseButtonPressed(button) {
                    _mouseButtonState[button] = MouseButtonState(pressedState: .notPressed, changeTime: currentTime)
                }
            case .move:
                break
            }
            _mousePosition = payload.position
        default:
            break
        }
    }

    public func keyboardKeyState(_ key: KeyboardEventPayload.PhysicalKey) -> (PressedState, Duration) {
        if let state = _keyboardKeyState[key] {
            return (state.pressedState, _currentFrameTime!.timeSinceStartup - state.changeTime)
        }
        return (.notPressed, .infinite)
    }

    public func isKeyboardKeyPressed(_ key: KeyboardEventPayload.PhysicalKey) -> Bool {
        let (pressedState, _) = keyboardKeyState(key)
        return pressedState == .pressed
    }

    public func mouseButtonState(_ button: MouseEventPayload.Button) -> (PressedState, Duration) {
        if let state = _mouseButtonState[button] {
            return (state.pressedState, _currentFrameTime!.timeSinceStartup - state.changeTime)
        }
        return (.notPressed, .infinite)
    }

    public func isMouseButtonPressed(_ button: MouseEventPayload.Button) -> Bool {
        let (pressedState, _) = mouseButtonState(button)
        return pressedState == .pressed
    }

    public var mousePosition: Vector2? {
        return _mousePosition
    }
}
