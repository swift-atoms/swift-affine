internal import Addition
internal import Cardinal
internal import Magnitude
internal import Polarity
public import Difference
internal import Subtraction
public import Tagged

extension Affine {
    public struct Position<Domain: ~Copyable & ~Escapable>: Sendable, Hashable {
        public typealias Offset = Tagged<Domain, Difference>

        public let rawValue: Int64

        @inlinable
        public init(rawValue: Int64) {
            self.rawValue = rawValue
        }
    }
}

extension Affine.Position where Domain: ~Copyable & ~Escapable {
    public func advanced(by offset: Offset) throws(Error) -> Self {
        let magnitude = Int128(offset.underlying.magnitude.value.rawValue)
        let displacement = offset.underlying.polarity == .negative ? -magnitude : magnitude
        let result = Addition.reporting(Int128(rawValue), displacement).value
        guard let rawValue = Int64(exactly: result) else { throw .overflow }
        return Self(rawValue: rawValue)
    }

    public func retreated(by offset: Offset) throws(Error) -> Self {
        try advanced(by: Offset(_unchecked: -offset.underlying))
    }

    public func distance(to other: Self) -> Offset {
        let displacement = Subtraction.reporting(
            Int128(other.rawValue), Int128(rawValue)
        ).value
        let difference = Difference(
            polarity: displacement < 0 ? .negative : .positive,
            magnitude: Difference.Magnitude(Cardinal(UInt(displacement.magnitude)))
        )
        return Offset(_unchecked: difference)
    }
}

extension Affine.Position where Domain: ~Copyable & ~Escapable {
    public static func + (lhs: Self, rhs: Offset) throws(Error) -> Self {
        try lhs.advanced(by: rhs)
    }

    public static func + (lhs: Offset, rhs: Self) throws(Error) -> Self {
        try rhs.advanced(by: lhs)
    }

    public static func - (lhs: Self, rhs: Offset) throws(Error) -> Self {
        try lhs.retreated(by: rhs)
    }

    public static func - (lhs: Self, rhs: Self) -> Offset {
        rhs.distance(to: lhs)
    }
}

#if !hasFeature(Embedded)
extension Affine.Position: Swift.Codable where Domain: ~Copyable & ~Escapable {}
#endif
