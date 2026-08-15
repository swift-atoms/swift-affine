// Affine.Discrete.Region.swift
// A positioned extent on the discrete line.

public import Cardinal_Primitives
public import Ordinal_Primitives

extension Affine.Discrete {
    /// A positioned extent on the discrete line: a start position and a count.
    ///
    /// `Region` models the half-open run `start ..< start + count` of `count` consecutive
    /// positions beginning at `start`. An empty region (`count == 0`) is permitted and
    /// contains nothing — its `end` equals its `start`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let run = Affine.Discrete.Region(start: 3, count: 4)   // positions 3, 4, 5, 6
    /// run.end                  // 7
    /// run.contains(6)          // true
    /// run.translated(by: 2)    // start 5, count 4
    /// ```
    public struct Region: Sendable {
        /// The first position in the region.
        public let start: Ordinal

        /// The number of positions in the region (may be zero).
        public let count: Cardinal

        /// Creates a region from a start position and a count.
        @inlinable
        public init(start: Ordinal, count: Cardinal) {
            self.start = start
            self.count = count
        }
    }
}

// MARK: - Equality, Hashing

// The `==` and `hash(into:)` witnesses live here in the type's own module (which has both
// Ordinal and Cardinal in scope) so they witness both the implicit stdlib conformance and the
// institute Equation.Protocol / Hash.Protocol twins declared in the Affine Equation / Hash
// sub-targets.

extension Affine.Discrete.Region {
    /// Compares two regions for equality by their start position and count.
    @inlinable
    public static func == (lhs: Affine.Discrete.Region, rhs: Affine.Discrete.Region) -> Bool {
        lhs.start == rhs.start && lhs.count == rhs.count
    }

    /// Feeds this region's start position and count into `hasher`.
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start.rawValue)
        hasher.combine(count.rawValue)
    }
}

// MARK: - Extent

extension Affine.Discrete.Region {
    /// The position one past the last.
    ///
    /// `start` advanced by `count` (saturating at the maximum representable
    /// position). For an empty region this equals `start`.
    @inlinable
    public var end: Ordinal {
        start.advance.saturating(by: count)
    }

    /// The half-open range of positions `start ..< end`.
    @inlinable
    public var range: Range<Ordinal> {
        start..<end
    }

    /// Whether the region contains the given position.
    @inlinable
    public func contains(_ position: Ordinal) -> Bool {
        position >= start && position < end
    }

    /// The region shifted by a signed displacement, keeping its count (saturating at `0` /
    /// the maximum).
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

// MARK: - Codable

// Ordinal / Cardinal are not themselves Codable, so the conformance is manual: encode the two
// underlying unsigned values as an unkeyed pair.
#if !hasFeature(Embedded)
    extension Affine.Discrete.Region: Codable {
        // WHY: signature forced by external protocol Swift.Decodable —
        // init(from:) requires untyped throws and an existential decoder.
        /// Decodes a region from an unkeyed pair of unsigned values.
        @inlinable
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let start = try container.decode(UInt.self)
            let count = try container.decode(UInt.self)
            self.init(start: Ordinal(start), count: Cardinal(integerLiteral: count))
        }

        // WHY: signature forced by external protocol Swift.Encodable —
        // encode(to:) requires untyped throws and an existential encoder.
        /// Encodes this region as an unkeyed pair of unsigned values.
        @inlinable
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(start.rawValue)
            try container.encode(count.rawValue)
        }
    }
#endif
