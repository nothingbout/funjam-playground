import Foundation

public struct Rect: Equatable, Hashable, Sendable {
    public var position: Vector2
    public var size: Vector2

    public init(position: Vector2, size: Vector2) {
        self.position = position
        self.size = size
    }
}
