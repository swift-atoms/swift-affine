public import Cardinal_Primitives
public import Ordinal_Primitives

extension Affine.Discrete {

    public struct Region: Sendable {

        public let start: Ordinal

        public let count: Cardinal

        @inlinable
        public init(start: Ordinal, count: Cardinal) {
            self.start = start
            self.count = count
        }
    }
}

extension Affine.Discrete.Region {

    @inlinable
    public static func == (lhs: Affine.Discrete.Region, rhs: Affine.Discrete.Region) -> Bool {
        lhs.start == rhs.start && lhs.count == rhs.count
    }

    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.rawValue)
        hasher.combine(count.rawValue)
    }
}

extension Affine.Discrete.Region {

    @inlinable
    public var end: Ordinal {
        start.advance.saturating(by: count)
    }

    @inlinable
    public var range: Range<Ordinal> {
        start..<end
    }

    @inlinable
    public func contains(_ position: Ordinal) -> Bool {
        position >= start && position < end
    }

    @inlinable
    public func translated(by displacement: Affine.Discrete.Vector) -> Affine.Discrete.Region {
        let shifted: Ordinal
        if displacement.rawValue >= 0 {
            shifted = start.advance.saturating(
                by: Cardinal(integerLiteral: UInt(displacement.rawValue))
            )
        } else {
            shifted = start.retreat.clamped(
                by: Cardinal(integerLiteral: UInt(-displacement.rawValue)),
                to: 0
            )
        }
        return Affine.Discrete.Region(start: shifted, count: count)
    }
}

#if !hasFeature(Embedded)
    extension Affine.Discrete.Region: Codable {

        @inlinable
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let start = try container.decode(UInt.self)
            let count = try container.decode(UInt.self)
            self.init(start: Ordinal(start), count: Cardinal(integerLiteral: count))
        }

        @inlinable
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(start.rawValue)
            try container.encode(count.rawValue)
        }
    }
#endif
