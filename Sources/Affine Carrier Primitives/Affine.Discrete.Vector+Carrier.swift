public import Affine_Discrete_Primitives
public import Carrier_Primitives

extension Affine.Discrete.Vector: Carrier.`Protocol` {

    public typealias Underlying = Affine.Discrete.Vector

}

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {

    @inlinable
    public var vector: Affine.Discrete.Vector { underlying }
}

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {

    @inlinable
    public static var zero: Self { Self(Affine.Discrete.Vector(0)) }

    @inlinable
    public static var one: Self { Self(Affine.Discrete.Vector(1)) }
}

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(Affine.Discrete.Vector(lhs.vector.rawValue + rhs.vector.rawValue))
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(Affine.Discrete.Vector(lhs.vector.rawValue - rhs.vector.rawValue))
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

@inlinable
public prefix func - <V>(v: V) -> V
where V: Carrier.`Protocol`, V.Underlying == Affine.Discrete.Vector {
    V(Affine.Discrete.Vector(-v.vector.rawValue))
}
