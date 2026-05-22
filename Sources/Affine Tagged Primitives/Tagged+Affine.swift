// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Affine_Arithmetic_Primitives
public import Affine_Carrier_Primitives
public import Affine_Discrete_Primitives
public import Cardinal_Primitives
public import Carrier_Primitives
public import Ordinal_Primitives
public import Tagged_Primitives

// MARK: - Tagged Affine Arithmetic
//
// Tagged wrappers for affine space operations with phantom type safety.
//
// Affine operations:
// - Point + Vector → Point (translation)
// - Point - Vector → Point (translation)
// - Point - Point → Vector (displacement)
// - Vector + Vector → Vector (vector addition)
// - Vector - Vector → Vector (vector subtraction)

// MARK: - Tagged<Tag, Ordinal>.Offset Typealias

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// The displacement type for this tagged ordinal.
    ///
    /// Wraps `Affine.Discrete.Vector` to maintain phantom type safety.
    ///
    /// ## Semantic Model
    ///
    /// An offset is the result of subtracting two ordinal positions:
    /// - `position2 - position1 → offset`
    /// - `position1 + offset → position2`
    ///
    /// ## Tagged Functor
    ///
    /// As a Tagged typealias, `Offset` gains:
    /// - `retag(_:)` for zero-cost cross-domain conversion
    /// - `map(_:)` for value transformation
    /// - Automatic `Equatable`, `Hashable`, `Comparable`, `Sendable` conformances
    ///
    /// ## Example
    ///
    /// ```swift
    /// let forward = Tagged<Element, Ordinal>.Offset(5)
    /// let backward = Tagged<Element, Ordinal>.Offset(-3)
    /// let combined = forward + backward  // Offset(2)
    ///
    /// // Cross-domain conversion via retag
    /// let other: Tagged<Other, Ordinal>.Offset = forward.retag(Other.self)
    /// ```
    public typealias Offset = Tagged<Tag, Affine.Discrete.Vector>
}

// MARK: - Tagged<Tag, Vector> Properties and Constants

extension Tagged where Underlying == Affine.Discrete.Vector, Tag: ~Copyable {
    // `var vector: Affine.Discrete.Vector` provided by
    // `extension Carrier.\`Protocol\` where Underlying == Affine.Discrete.Vector`
    // in Affine.Discrete.Vector+Carrier.swift (synonym for `underlying`).
    //
    // .zero / .one provided by the same Carrier-of-Vector extension.

    /// The magnitude of this offset as a tagged cardinal.
    ///
    /// Preserves the phantom tag: the magnitude of a bit displacement
    /// is a bit count, the magnitude of an element displacement is an
    /// element count.
    ///
    /// Same-Tag identity is enforced structurally by the type system.
    @inlinable
    public var magnitude: Tagged<Tag, Cardinal> {
        .init(_unchecked: vector.magnitude)
    }
}

// MARK: - Tagged<Tag, Vector> Construction

extension Tagged where Underlying == Affine.Discrete.Vector, Tag: ~Copyable {
    /// Creates a tagged vector with the given signed value.
    @inlinable
    public init(
        _ underlying: Int
    ) {
        self.init(_unchecked: Affine.Discrete.Vector(underlying))
    }

    /// Creates a tagged vector from a tagged cardinal.
    ///
    /// This is a total operation since cardinals are always non-negative.
    @inlinable
    public init<T: ~Copyable>(
        _ count: Tagged<T, Cardinal>
    ) {
        self.init(_unchecked: Affine.Discrete.Vector(Int(bitPattern: count)))
    }

    /// Creates a tagged vector representing the displacement from origin to position.
    ///
    /// This is the canonical affine decomposition: `position = origin + offset`.
    ///
    /// - Throws: `Affine.Discrete.Vector.Error.unrepresentable` if the position
    ///   exceeds `Int.max` and cannot be represented as a signed displacement.
    @inlinable
    public init(
        _ index: some Ordinal.`Protocol`
    ) throws(Affine.Discrete.Vector.Error) {
        self.init(_unchecked: try index.ordinal - Ordinal.zero)
    }

    /// Creates a tagged vector representing displacement from origin, without validation.
    ///
    /// Use this initializer when the index is known to be ≤ `Int.max` by construction
    /// (e.g., indices derived from bounded containers with `Int` capacity).
    ///
    /// - Warning: If `index > Int.max`, the resulting offset will be incorrect
    ///   (negative due to signed/unsigned bit reinterpretation). Only use when
    ///   the caller guarantees the index is representable.
    @inlinable
    public init(
        _unchecked: Void,
        _ ordinal: some Ordinal.`Protocol`
    ) {
        assert(
            ordinal.ordinal.rawValue <= UInt(Int.max),
            "Ordinal exceeds Int.max; cannot represent as signed Vector"
        )
        self.init(_unchecked: Affine.Discrete.Vector(Int(bitPattern: ordinal)))
    }

    /// Creates an offset representing the distance from zero to the given position.
    ///
    /// This explicitly encodes the assumption that the offset is measured from
    /// the zero position, making the origin clear at call sites.
    ///
    /// ## Affine Semantics
    ///
    /// A position (ordinal) is a point in affine space, not a vector. It becomes
    /// a vector only when measured relative to an origin. This initializer makes
    /// that "from zero" assumption explicit:
    ///
    /// ```swift
    /// let position: Ordinal = ...
    /// let offset = Tagged<Element, Ordinal>.Offset(fromZero: position)
    ///
    /// let taggedPosition: Tagged<Element, Ordinal> = ...
    /// let taggedOffset = Tagged<Element, Ordinal>.Offset(fromZero: taggedPosition)
    /// ```
    ///
    /// - Parameter position: The ordinal position to convert to an offset from zero.
    @inlinable
    public init(fromZero position: some Ordinal.`Protocol`) {
        self.init(Affine.Discrete.Vector(Int(bitPattern: position)))
    }
}

// MARK: - Tagged<Tag, Ordinal> - Tagged<Tag, Vector> → Tagged<Tag, Ordinal>

extension Tagged where Underlying == Ordinal, Tag: ~Copyable {
    /// Retreats a tagged ordinal by a tagged vector.
    ///
    /// This is the concrete operator for the affine retreat `Point - Vector → Point`.
    /// It delegates to the generic affine operator (`Affine.Discrete+Arithmetic.swift`)
    /// and provides the exact `Tagged<Tag, Affine.Discrete.Vector>` parameter type.
    ///
    /// - Throws: `Ordinal.Error.underflow` if the result would be negative.
    /// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
    @inlinable
    public static func - (lhs: Self, rhs: Tagged<Tag, Affine.Discrete.Vector>) throws(Ordinal.Error) -> Self {
        try Self(lhs.ordinal - rhs.vector)
    }

    /// Retreats a tagged ordinal by a tagged vector in place.
    ///
    /// - Throws: `Ordinal.Error.underflow` if the result would be negative.
    /// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Tagged<Tag, Affine.Discrete.Vector>) throws(Ordinal.Error) {
        lhs = try lhs - rhs
    }
}

// MARK: - Tagged<Tag, Cardinal> from Tagged<Tag, Vector> Conversion

extension Tagged where Underlying == Cardinal, Tag: ~Copyable {
    /// Creates a tagged cardinal from a non-negative tagged vector.
    ///
    /// - Throws: `Cardinal.Error.negativeSource` if vector is negative.
    @inlinable
    public init(
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) throws(Cardinal.Error) {
        guard offset.vector.rawValue >= 0 else {
            throw .negativeSource(offset.vector.rawValue)
        }
        self.init(_unchecked: Cardinal(UInt(offset.vector.rawValue)))
    }

    /// Creates a tagged cardinal from a tagged vector without validation.
    ///
    /// - Warning: No validation is performed. Use only when the vector is known
    ///   to be non-negative.
    @inlinable
    public init(
        _unchecked: Void,
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) {
        assert(offset.vector.rawValue >= 0, "Vector must be non-negative for unchecked Cardinal conversion")
        self.init(_unchecked: Cardinal(UInt(offset.vector.rawValue)))
    }
}

// MARK: - Ordinal.Protocol - Ordinal.Protocol → Tagged<Tag, Vector>

/// Returns the signed displacement between two ordinals.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
///
/// - Throws: `Affine.Discrete.Vector.Error` if the difference is unrepresentable.
@inlinable
public func - <Tag: ~Copyable>(
    lhs: some Ordinal.`Protocol`,
    rhs: some Ordinal.`Protocol`
) throws(Affine.Discrete.Vector.Error) -> Tagged<Tag, Affine.Discrete.Vector> {
    Tagged<Tag, Affine.Discrete.Vector>(_unchecked: try lhs.ordinal - rhs.ordinal)
}

// Vector ↔ Cardinal comparisons unified via Domain in Affine.Discrete+Arithmetic.swift.

// MARK: - Tagged<From, Cardinal> * Ratio<From, To> → Tagged<To, Cardinal>

/// Scales a tagged cardinal from one domain to another.
///
/// This converts a cardinality from the source domain to the target domain.
/// The value is multiplied by the ratio's factor.
///
/// - Precondition: The scaled result must be non-negative.
@inlinable
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Tagged<From, Cardinal>,
    rhs: Affine.Discrete.Ratio<From, To>
) -> Tagged<To, Cardinal> {
    // Boundary conversion isolated from the arithmetic per [CONV-010] /
    // [IMPL-010] — `Int(bitPattern:)` grounds the unsigned receiver into
    // stdlib signed arithmetic; the `*` then operates on already-signed Ints.
    let signedLHS = Int(bitPattern: lhs)
    let result = signedLHS * rhs.factor
    precondition(result >= 0, "Scaled cardinal must be non-negative")
    return Tagged<To, Cardinal>(_unchecked: Cardinal(UInt(result)))
}

/// Scales a tagged cardinal from one domain to another (commutative).
@inlinable
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Affine.Discrete.Ratio<From, To>,
    rhs: Tagged<From, Cardinal>
) -> Tagged<To, Cardinal> {
    rhs * lhs
}

// MARK: - Tagged<From, Vector> * Ratio<From, To> → Tagged<To, Vector>

/// Scales a tagged vector from one domain to another.
///
/// This is the fundamental action of a ratio on a vector. The magnitude is
/// multiplied by the ratio's factor, and the domain changes from `From` to `To`.
@inlinable
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Tagged<From, Affine.Discrete.Vector>,
    rhs: Affine.Discrete.Ratio<From, To>
) -> Tagged<To, Affine.Discrete.Vector> {
    Tagged<To, Affine.Discrete.Vector>(_unchecked: Affine.Discrete.Vector(lhs.vector.rawValue * rhs.factor))
}

/// Scales a tagged vector from one domain to another (commutative).
@inlinable
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Affine.Discrete.Ratio<From, To>,
    rhs: Tagged<From, Affine.Discrete.Vector>
) -> Tagged<To, Affine.Discrete.Vector> {
    rhs * lhs
}
