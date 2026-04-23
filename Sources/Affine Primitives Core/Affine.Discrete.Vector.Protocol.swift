// Affine.Discrete.Vector.Protocol.swift
// Abstraction over types that carry a discrete affine vector.

public import Tagged_Primitives

// MARK: - Protocol

extension Affine.Discrete.Vector {
    /// A type that carries a discrete affine vector (displacement).
    ///
    /// Conforming types wrap or represent an `Affine.Discrete.Vector` value
    /// and can round-trip through it. This enables generic operations to accept
    /// both bare `Affine.Discrete.Vector` and phantom-typed wrappers like
    /// `Index<T>.Offset` without rawValue extraction.
    ///
    /// ## Conformers
    ///
    /// - `Affine.Discrete.Vector` — identity (self-conformance)
    /// - `Tagged<Tag, Affine.Discrete.Vector>` — phantom-typed vector wrapper
    ///
    /// ## Example
    ///
    /// ```swift
    /// func negate<V: Affine.Discrete.Vector.`Protocol`>(_ value: V) -> V {
    ///     V(Affine.Discrete.Vector(-value.vector.rawValue))
    /// }
    /// ```
    public protocol `Protocol` {
        /// The domain that scopes this vector displacement.
        ///
        /// For bare `Affine.Discrete.Vector`, `Domain` is `Never` (unscoped).
        /// For `Tagged<Tag, Affine.Discrete.Vector>`, `Domain` is `Tag`,
        /// enabling cross-type operators to enforce same-tag safety via
        /// `where V.Domain == C.Domain`.
        associatedtype Domain: ~Copyable

        /// The underlying vector value.
        var vector: Affine.Discrete.Vector { get }

        /// Creates an instance from a vector value.
        init(_ vector: Affine.Discrete.Vector)
    }
}

// MARK: - Vector Conformance

extension Affine.Discrete.Vector: Affine.Discrete.Vector.`Protocol` {
    /// Bare vectors are unscoped.
    public typealias Domain = Never

    /// Returns self.
    @inlinable
    public var vector: Affine.Discrete.Vector { self }

    /// Creates a vector from a vector (identity).
    @inlinable
    public init(_ vector: Affine.Discrete.Vector) {
        self = vector
    }
}

// MARK: - Tagged Conformance

extension Tagged: Affine.Discrete.Vector.`Protocol` where RawValue == Affine.Discrete.Vector, Tag: ~Copyable {
    /// The phantom type is the domain.
    public typealias Domain = Tag
}

// MARK: - Constants

extension Affine.Discrete.Vector.`Protocol` {
    /// The zero vector (additive identity).
    ///
    /// Available at the affine layer because `.zero` is the group identity
    /// for the additive group structure fundamental to affine space.
    @inlinable
    public static var zero: Self { Self(Affine.Discrete.Vector(0)) }
}

// MARK: - Arithmetic

extension Affine.Discrete.Vector.`Protocol` {
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
public prefix func - <V: Affine.Discrete.Vector.`Protocol`>(v: V) -> V {
    V(Affine.Discrete.Vector(-v.vector.rawValue))
}
