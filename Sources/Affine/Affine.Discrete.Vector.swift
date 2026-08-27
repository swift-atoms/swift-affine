public import Cardinal

extension Affine.Discrete {

    public struct Vector {

        public let rawValue: Int

        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    @available(*, deprecated, renamed: "Vector")
    public typealias Displacement = Vector
}

extension Affine.Discrete.Vector: Sendable {}

extension Affine.Discrete.Vector {

    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue >= rhs.rawValue
    }

    @inlinable
    public var magnitude: Cardinal {
        Cardinal(rawValue.magnitude)
    }
}

extension Affine.Discrete.Vector: CustomStringConvertible {

    public var description: String {
        "Vector(\(rawValue))"
    }
}

extension Affine.Discrete.Vector: ExpressibleByIntegerLiteral {

    @inlinable
    @_disfavoredOverload
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

extension Affine.Discrete.Vector: Equatable {}
extension Affine.Discrete.Vector: Hashable {}

extension Affine.Discrete.Vector: Comparable {}

extension Affine.Discrete.Vector {

    @inlinable
    public static var zero: Self { Self(0) }

    @inlinable
    public static var one: Self { Self(1) }

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value.rawValue)
    }
}
