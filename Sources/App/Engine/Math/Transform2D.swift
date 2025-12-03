import Foundation

public struct Transform2D: Equatable, Hashable, Sendable {
    public var position: Vector2
    public var rotation: Angle
    public var scale: Vector2
    public var depth: Double

    public init(position: Vector2, rotation: Angle, scale: Vector2, depth: Double) {
        self.position = position
        self.rotation = rotation
        self.scale = scale
        self.depth = depth
    }
}
