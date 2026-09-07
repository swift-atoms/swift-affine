public import Tagged

extension Affine {
    /// A point in a named affine domain, represented relative to a caller-chosen origin.
    /// Points translate by domain-tagged offsets; subtracting points yields an offset.
    /// There is deliberately no point-plus-point operation.
    public struct Point<Domain, Translation: AdditiveArithmetic> {
        public let coordinates: Translation
        public typealias Offset = Tagged<Domain, Translation>

        public init(coordinates: Translation) {
            self.coordinates = coordinates
        }

        public func translated(by offset: Offset) -> Self {
            Self(coordinates: coordinates + offset.underlying)
        }

        public func displacement(to other: Self) -> Offset {
            Offset(_unchecked: other.coordinates - coordinates)
        }
    }
}

extension Affine.Point: Swift.Equatable where Translation: Swift.Equatable {}

extension Affine.Point: Swift.Hashable where Translation: Swift.Hashable {}

extension Affine.Point: Swift.Sendable where Translation: Swift.Sendable {}
