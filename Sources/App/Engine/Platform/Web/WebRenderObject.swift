import Foundation
import JavaScriptKit

private extension RenderData {
    func canBeUpdatedTo(_ other: RenderData) -> Bool {
        switch (self, other) {
        case (.text, .text):
            return true
        case (.rectangle, .rectangle):
            return true
        default:
            return false
        }
    }
}

class WebRenderObject {
    private let _element: JSValue
    private var _frameTime: FrameTime
    private var _transform: Transform2D
    private var _color: Color
    private var _data: RenderData
    private var _renderScale: Double

    public var frameTime: FrameTime { _frameTime }

    init(document: JSValue, container: JSValue, frameTime: FrameTime, renderObject: RenderObject, renderScale: Double) {
        _element = document.createElement("div")
        _element.style.position = "absolute"
        _element.style.transformOrigin = "center center"
        _frameTime = frameTime
        _transform = renderObject.transform
        _color = renderObject.color
        _data = renderObject.data
        _renderScale = renderScale
        updateTransform(renderObject.transform)
        updateColor(renderObject.color)
        updateData(renderObject.data)
        _ = container.appendChild(_element)
    }

    func destroy() {
        _ = _element.remove()
    }

    func update(frameTime: FrameTime, renderObject: RenderObject, renderScale: Double) -> Bool {
        if _data != renderObject.data {
            if !_data.canBeUpdatedTo(renderObject.data) {
                return false
            }
            updateData(renderObject.data)
        }
        var renderScaleChanged = false
        if renderScale != _renderScale {
            _renderScale = renderScale
            renderScaleChanged = true
        }
        if _transform != renderObject.transform || renderScaleChanged {
            updateTransform(renderObject.transform)
        }
        if _color != renderObject.color {
            updateColor(renderObject.color)
        }
        _frameTime = frameTime
        return true
    }

    func updateTransform(_ transform: Transform2D) {
        _transform = transform
        let pos = transform.position * _renderScale
        let degrees = transform.rotation.degrees
        let scale = transform.scale * _renderScale
        _element.style.transform = "translate(-50%, -50%) translate3d(\(pos.x)px, \(pos.y)px, \(-transform.depth)px) rotate(\(degrees)deg) scale(\(scale.x), \(scale.y))".jsValue
    }

    func updateColor(_ color: Color) {
        _color = color
        switch _data {
        case .text:
            _element.style.color = color.toHexString().jsValue
        case .rectangle:
            _element.style.backgroundColor = color.toHexString().jsValue
        }
    }
    
    func updateData(_ data: RenderData) {
        _data = data
        switch data {
        case .text(let text, let fontSize):
            _element.textContent = text.jsValue
            _element.style.fontSize = "\(fontSize)px".jsValue
        case .rectangle(let width, let height):
            _element.style.width = "\(width)px".jsValue
            _element.style.height = "\(height)px".jsValue
            break
        }
    }
}
