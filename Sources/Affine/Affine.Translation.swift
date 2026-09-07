public import Difference
public import Tagged

extension Affine {
    /// A fixed translation that preserves the coordinate domain and unit.
    public struct Translation<Domain: ~Copyable & ~Escapable>: Sendable, Hashable {
        public typealias Position = Affine.Position<Domain>
        public typealias Offset = Position.Offset

        public let offset: Offset

        @inlinable
        public init(offset: Offset) {
            self.offset = offset
        }
    }
}

extension Affine.Translation where Domain: ~Copyable & ~Escapable {
    public static var identity: Self {
        Self(offset: Offset(_unchecked: .zero))
    }

    public func inverted() -> Self {
        Self(offset: Offset(_unchecked: -offset.underlying))
    }

    public func applying(to position: Position) throws(Position.Error) -> Position {
        try position.advanced(by: offset)
    }

    /// Composes two translations, failing if the combined difference cannot fit.
    public func composed(with next: Self) throws(Difference.Error) -> Self {
        Self(offset: Offset(_unchecked: try offset.underlying.add.exact(next.offset.underlying)))
    }
}

#if !hasFeature(Embedded)
extension Affine.Translation: Swift.Codable where Domain: ~Copyable & ~Escapable {}
#endif
