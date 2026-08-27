public import Cardinal
public import Ordinal

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
        let (sum, overflow) = start.rawValue.addingReportingOverflow(count.rawValue)
        return Ordinal(overflow ? UInt.max : sum)
    }

    @inlinable
    public func contains(_ position: Ordinal) -> Bool {
        position >= start && position < end
    }

    @inlinable
    public func translated(by displacement: Affine.Discrete.Vector) -> Affine.Discrete.Region {
        let shifted: Ordinal
        if displacement.rawValue >= 0 {
            let magnitude = UInt(displacement.rawValue)
            let (sum, overflow) = start.rawValue.addingReportingOverflow(magnitude)
            shifted = Ordinal(overflow ? UInt.max : sum)
        } else {
            let magnitude = UInt(-displacement.rawValue)
            shifted = Ordinal(start.rawValue >= magnitude ? start.rawValue - magnitude : 0)
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
            self.init(start: Ordinal(start), count: Cardinal(count))
        }

        @inlinable
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(start.rawValue)
            try container.encode(count.rawValue)
        }
    }
#endif
