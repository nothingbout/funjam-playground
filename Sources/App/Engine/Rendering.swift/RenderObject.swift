import Foundation
import Synchronization

public enum RenderData: Equatable, Sendable {
    case text(text: String, fontSize: Double)
    case rectangle(width: Double, height: Double)
}

public struct RenderObjectId: Equatable, Hashable, Sendable {
    private static let _nextValue = Atomic<UInt64>(1)

    private let _value: UInt64

    public init() {
        (_value, _) = Self._nextValue.wrappingAdd(1, ordering: .relaxed)
    }
}

public class RenderObject {
    public private(set) var id: RenderObjectId
    public var transform: Transform2D
    public var color: Color
    public var data: RenderData

    public required init(transform: Transform2D, color: Color, data: RenderData) {
        id = RenderObjectId()
        self.transform = transform
        self.color = color
        self.data = data
    }

    public static func line(from: Vector2, to: Vector2, width lineWidth: Double, color: Color, depth: Double) -> Self {
        let (direction, length) = (to - from).directionAndMagnitude()
        return Self(
            transform: Transform2D(
                position: Vector2.lerp(from, to, by: 0.5),
                rotation: direction.angle(),
                scale: Vector2(1.0, 1.0),
                depth: depth
            ),
            color: color,
            data: .rectangle(width: length, height: lineWidth)
        )
    }
}
