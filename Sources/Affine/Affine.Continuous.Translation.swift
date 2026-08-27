public import Dimension
public import Linear
public import Tagged

extension Affine.Continuous {

    public struct Translation {

        public var dx: Linear<Scalar, Space>.Dx

        public var dy: Linear<Scalar, Space>.Dy

        @inlinable
        public init(dx: Linear<Scalar, Space>.Dx, dy: Linear<Scalar, Space>.Dy) {
            self.dx = dx
            self.dy = dy
        }
    }
}

extension Affine.Continuous.Translation: Sendable where Scalar: Sendable {}
extension Affine.Continuous.Translation: Equatable where Scalar: Equatable {}
extension Affine.Continuous.Translation: Hashable where Scalar: Hashable {}

#if !hasFeature(Embedded)
    extension Affine.Continuous.Translation: Codable where Scalar: Codable {

        private enum CodingKeys: String, CodingKey {
            case dx
            case dy
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.dx = .init(_unchecked: try container.decode(Scalar.self, forKey: .dx))
            self.dy = .init(_unchecked: try container.decode(Scalar.self, forKey: .dy))
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(dx.underlying, forKey: .dx)
            try container.encode(dy.underlying, forKey: .dy)
        }
    }
#endif

extension Affine.Continuous.Translation {

    @inlinable
    public init(_ vector: Linear<Scalar, Space>.Vector<2>) {
        self.dx = vector.dx
        self.dy = vector.dy
    }
}

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {

    @inlinable
    public static var zero: Self {
        Self(dx: .zero, dy: .zero)
    }
}

extension Affine.Continuous.Translation where Scalar: AdditiveArithmetic {

    @inlinable
    @_disfavoredOverload
    public static func + (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    @inlinable
    @_disfavoredOverload
    public static func - (lhs: borrowing Self, rhs: borrowing Self) -> Self {
        Self(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

extension Affine.Continuous.Translation where Scalar: SignedNumeric {

    @inlinable
    public static prefix func - (value: borrowing Self) -> Self {
        Self(dx: -value.dx, dy: -value.dy)
    }
}

extension Affine.Continuous.Translation {

    @inlinable
    public var vector: Linear<Scalar, Space>.Vector<2> {
        Linear<Scalar, Space>.Vector(dx: dx, dy: dy)
    }
}
