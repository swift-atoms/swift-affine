extension Affine.Discrete {

    public struct Ratio<From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>: Hashable,
        Sendable
    {

        public let factor: Int

        @inlinable
        public init(_ factor: Int) {
            self.factor = factor
        }
    }
}

extension Affine.Discrete.Ratio where From == To, From: ~Copyable & ~Escapable {

    @inlinable
    public static var identity: Self {
        Self(1)
    }

    @inlinable
    public static var negate: Self {
        Self(-1)
    }
}

extension Affine.Discrete.Ratio: CustomStringConvertible
where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {

    public var description: String {
        "Ratio<\(From.self), \(To.self)>(\(factor))"
    }
}

extension Affine.Discrete.Ratio: ExpressibleByIntegerLiteral
where From == To, From: ~Copyable & ~Escapable {

    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
