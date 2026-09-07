public import Tagged

extension Affine {
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
