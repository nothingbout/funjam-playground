import Foundation
import JavaScriptKit

class WebRenderer {
    private let _document: JSValue
    private let _container: JSValue

    private var _frameTime: FrameTime? = nil
    private var _clientRect: Rect? = nil
    private var _renderObjects: [RenderObjectId: WebRenderObject] = [:]
    private var _objectsToRemove: [RenderObjectId] = []

    public var renderScale: Double = 1.0
    public var backingSize: Vector2 { _clientRect!.size }
    public var operationalSize: Vector2 { backingSize / renderScale }

    init(document: JSValue, container: JSValue) {
        _document = document
        _container = container
    }

    public func position(of mouseEventPayload: MouseEventPayload) -> Vector2 {
        let position = mouseEventPayload.position
        return position - _clientRect!.position
    }

    func startFrame(_ frameTime: FrameTime) {
        _frameTime = frameTime

        let domRect = _container.getBoundingClientRect()
        _clientRect = Rect(
            position: Vector2(domRect.left.number!, domRect.top.number!), 
            size: Vector2(domRect.width.number!, domRect.height.number!)
        )
    }

    public func drawObject(_ renderObject: RenderObject) {
        if let existing = _renderObjects[renderObject.id] {
            if existing.update(frameTime: _frameTime!, renderObject: renderObject, renderScale: renderScale) {
                return
            }
            existing.destroy()
        }

        let new = WebRenderObject(document: _document, container: _container, frameTime: _frameTime!, 
            renderObject: renderObject, renderScale: renderScale)
        _renderObjects[renderObject.id] = new
    }

    func endFrame() {
        _objectsToRemove.removeAll(keepingCapacity: true)
        for (id, object) in _renderObjects {
            if object.frameTime != _frameTime! {
                _objectsToRemove.append(id)
            }
        }
        for id in _objectsToRemove {
            let object = _renderObjects[id]!
            object.destroy()
            _renderObjects.removeValue(forKey: id)
        }
    }
}
