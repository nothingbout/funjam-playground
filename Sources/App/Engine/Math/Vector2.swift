import Foundation

public struct Vector2: Equatable, Hashable, Sendable {
    public var x: Double
    public var y: Double

    @inlinable public init(_ x: Double, _ y: Double) { self.x = x; self.y = y }
    public static let zero = Self(0.0, 0.0)

    public func withX(_ newX: Double) -> Self { return .init(newX, y) }
    public func withY(_ newY: Double) -> Self { return .init(x, newY) }

    @inlinable public static prefix func - (lhs: Self) -> Self { return .init(-lhs.x, -lhs.y) }
    @inlinable public static func + (lhs: Self, rhs: Self) -> Self { return .init(lhs.x + rhs.x, lhs.y + rhs.y) }
    @inlinable public static func - (lhs: Self, rhs: Self) -> Self { return .init(lhs.x - rhs.x, lhs.y - rhs.y) }
    @inlinable public static func * (lhs: Self, rhs: Double) -> Self { return .init(lhs.x * rhs, lhs.y * rhs) }
    @inlinable public static func / (lhs: Self, rhs: Double) -> Self { return .init(lhs.x / rhs, lhs.y / rhs) }

    @inlinable public static func += (lhs: inout Self, rhs: Self) { lhs = lhs + rhs }
    @inlinable public static func -= (lhs: inout Self, rhs: Self) { lhs = lhs - rhs }
    @inlinable public static func *= (lhs: inout Self, rhs: Double) { lhs = lhs * rhs }
    @inlinable public static func /= (lhs: inout Self, rhs: Double) { lhs = lhs / rhs }

    @inlinable public func map(_ f: (Double) -> Double) -> Self { return .init(f(x), f(y)) }
    @inlinable public func minValue() -> Double { return min(x, y) }
    @inlinable public func maxValue() -> Double { return max(x, y) }

    @inlinable public func approximately(other: Self, epsilon: Double = 1e-6) -> Bool {
        return abs(x - other.x) < epsilon && abs(y - other.y) < epsilon
    }

    @inlinable public func sqrMagnitude() -> Double { x * x + y * y }
    @inlinable public func magnitude() -> Double { sqrt(sqrMagnitude()) }

    @inlinable public func direction(epsilon: Double = 1e-6) -> Self {
        let (dir, _) = directionAndMagnitude(epsilon: epsilon)
        return dir
    }
    @inlinable public func directionAndMagnitude(epsilon: Double = 1e-6) -> (Self, Double) {
        let mag = magnitude()
        return mag > epsilon ? (self / mag, mag) : (.zero, 0.0)
    }

    @inlinable public func dot(other: Self) -> Double { x * other.x + y * other.y }
    @inlinable public func cross(other: Self) -> Double { x * other.y - y * other.x }

    @inlinable public func angle() -> Angle { return .radians(atan2(y, x)) }
    @inlinable public init(angle: Angle, magnitude: Double = 1.0) {
        self.x = magnitude * angle.cosine()
        self.y = magnitude * angle.sine()
    }

    @inlinable public func rotatedBy(_ angle: Angle) -> Self {
        let cos = angle.cosine();
        let sin = angle.sine();
        return .init(x * cos - y * sin, x * sin + y * cos)
    }

    @inlinable public func turned90(towards direction: WindingDirection) -> Self {
        switch direction {
        case .positiveAngle:
            return .init(-y, x)
        case .negativeAngle:
            return .init(y, -x)
        }
    }

    @inlinable public static func lerpUnclamped(_ a: Self, _ b: Self, by t: Double) -> Self {
        return .init(Math.lerpUnclamped(a.x, b.x, by: t), Math.lerpUnclamped(a.y, b.y, by: t))
    }
    @inlinable public static func lerp(_ a: Self, _ b: Self, by t: Double) -> Self {
        return lerpUnclamped(a, b, by: Math.clamp01(t))
    }
}
