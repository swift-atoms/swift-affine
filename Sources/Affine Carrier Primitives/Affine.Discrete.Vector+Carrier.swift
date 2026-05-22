// Affine.Discrete.Vector+Carrier.swift
// Affine.Discrete.Vector conforms to Carrier.`Protocol` as a trivial-self-carrier;
// per-type accessor + arithmetic + constants live as constrained extensions on
// `Carrier.`Protocol` where Underlying == Affine.Discrete.Vector`.

public import Affine_Discrete_Primitives
public import Carrier_Primitives

// MARK: - Carrier Conformance (trivial self-carrier)

extension Affine.Discrete.Vector: Carrier.`Protocol` {
    /// Affine.Discrete.Vector IS its own Underlying.
    public typealias Underlying = Affine.Discrete.Vector

    // `Domain` defaults to `Never` per the Carrier protocol declaration.
    // `var underlying` and `init(_:)` are inherited from the
    // `Carrier.`Protocol` where Underlying == Self` default extension.
}

// MARK: - Per-type Accessor

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {
    /// The underlying vector value.
    ///
    /// Synonym for `underlying` — preserves the per-type accessor name.
    @inlinable
    public var vector: Affine.Discrete.Vector { underlying }
}

// MARK: - Constants

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {
    /// The zero vector (additive identity).
    @inlinable
    public static var zero: Self { Self(Affine.Discrete.Vector(0)) }

    /// The unit vector (displacement of 1).
    @inlinable
    public static var one: Self { Self(Affine.Discrete.Vector(1)) }
}

// MARK: - Arithmetic

extension Carrier.`Protocol` where Underlying == Affine.Discrete.Vector {
    /// Adds two vectors.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(Affine.Discrete.Vector(lhs.vector.rawValue + rhs.vector.rawValue))
    }

    /// Subtracts two vectors.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(Affine.Discrete.Vector(lhs.vector.rawValue - rhs.vector.rawValue))
    }

    /// Adds a vector in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// Subtracts a vector in place.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

/// Negates a vector.
@inlinable
public prefix func - <V>(v: V) -> V where V: Carrier.`Protocol`, V.Underlying == Affine.Discrete.Vector {
    V(Affine.Discrete.Vector(-v.vector.rawValue))
}
