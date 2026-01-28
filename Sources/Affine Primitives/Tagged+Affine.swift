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

public import Ordinal_Primitives
public import Cardinal_Primitives

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

// MARK: - Tagged<Tag, Vector> Properties and Constants

extension Tagged where RawValue == Affine.Discrete.Vector, Tag: ~Copyable {
    /// The underlying vector (displacement).
    @inlinable
    public var vector: Affine.Discrete.Vector { rawValue }

    /// The zero offset (no displacement).
    @inlinable
    public static var zero: Self { Self(__unchecked: (), .zero) }

    /// The unit offset (displacement of 1).
    @inlinable
    public static var one: Self { Self(__unchecked: (), Affine.Discrete.Vector(1)) }
}

// MARK: - Tagged<Tag, Vector> Construction

extension Tagged where RawValue == Affine.Discrete.Vector, Tag: ~Copyable {
    /// Creates a tagged vector from a vector.
    @inlinable
    public init(
        _ vector: Affine.Discrete.Vector
    ) {
        self.init(__unchecked: (), vector)
    }

    /// Creates a tagged vector with the given signed value.
    @inlinable
    public init(
        _ rawValue: Int
    ) {
        self.init(__unchecked: (), Affine.Discrete.Vector(rawValue))
    }

    /// Creates a tagged vector from a tagged cardinal.
    ///
    /// This is a total operation since cardinals are always non-negative.
    @inlinable
    public init<T: ~Copyable>(_ count: Tagged<T, Cardinal>) {
        self.init(__unchecked: (), Affine.Discrete.Vector(Int(count.rawValue.rawValue)))
    }

    /// Creates a tagged vector representing the displacement from origin to position.
    ///
    /// This is the canonical affine decomposition: `position = origin + offset`.
    ///
    /// - Throws: `Affine.Discrete.Vector.Error.unrepresentable` if the position
    ///   exceeds `Int.max` and cannot be represented as a signed displacement.
    @inlinable
    public init(_ index: Tagged<Tag, Ordinal>) throws(Affine.Discrete.Vector.Error) {
        self = try index - .zero
    }
}

// MARK: - Tagged<Tag, Cardinal> from Tagged<Tag, Vector> Conversion

extension Tagged where RawValue == Cardinal, Tag: ~Copyable {
    /// Creates a tagged cardinal from a non-negative tagged vector.
    ///
    /// - Throws: `Cardinal.Error.negativeSource` if vector is negative.
    @inlinable
    public init(
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) throws(Cardinal.Error) {
        guard offset.rawValue.rawValue >= 0 else {
            throw .negativeSource(offset.rawValue.rawValue)
        }
        self.init(__unchecked: (), Cardinal(UInt(offset.rawValue.rawValue)))
    }

    /// Creates a tagged cardinal from a tagged vector without validation.
    ///
    /// - Warning: No validation is performed. Use only when the vector is known
    ///   to be non-negative.
    @inlinable
    public init(
        __unchecked: Void,
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) {
        assert(offset.rawValue.rawValue >= 0, "Vector must be non-negative for unchecked Cardinal conversion")
        self.init(__unchecked: (), Cardinal(UInt(offset.rawValue.rawValue)))
    }
}

// MARK: - Tagged<Tag, Ordinal> ± Tagged<Tag, Vector> → Tagged<Tag, Ordinal>

/// Advances a tagged ordinal by a tagged vector.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func + <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) throws(Ordinal.Error) -> Tagged<Tag, Ordinal> {
    Tagged<Tag, Ordinal>(__unchecked: (), try lhs.rawValue + rhs.rawValue)
}

/// Advances a tagged ordinal by a tagged vector (commutative).
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func + <Tag: ~Copyable>(
    lhs: Tagged<Tag, Affine.Discrete.Vector>,
    rhs: Tagged<Tag, Ordinal>
) throws(Ordinal.Error) -> Tagged<Tag, Ordinal> {
    try rhs + lhs
}

/// Retreats a tagged ordinal by a tagged vector.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func - <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) throws(Ordinal.Error) -> Tagged<Tag, Ordinal> {
    Tagged<Tag, Ordinal>(__unchecked: (), try lhs.rawValue - rhs.rawValue)
}

// MARK: - Tagged<Tag, Ordinal> - Tagged<Tag, Ordinal> → Tagged<Tag, Vector>

/// Returns the signed displacement between two tagged ordinals.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
///
/// - Throws: `Affine.Discrete.Vector.Error` if the difference is unrepresentable.
@inlinable
public func - <Tag: ~Copyable>(
    lhs: Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Ordinal>
) throws(Affine.Discrete.Vector.Error) -> Tagged<Tag, Affine.Discrete.Vector> {
    Tagged<Tag, Affine.Discrete.Vector>(__unchecked: (), try lhs.rawValue - rhs.rawValue)
}

// MARK: - Tagged<Tag, Vector> ± Tagged<Tag, Vector> → Tagged<Tag, Vector>

extension Tagged where RawValue == Affine.Discrete.Vector, Tag: ~Copyable {
    /// Adds two tagged vectors.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(__unchecked: (), lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts two tagged vectors.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(__unchecked: (), lhs.rawValue - rhs.rawValue)
    }

    /// Adds a tagged vector in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// Subtracts a tagged vector in place.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

/// Negates a tagged vector.
@inlinable
public prefix func - <Tag: ~Copyable>(
    v: Tagged<Tag, Affine.Discrete.Vector>
) -> Tagged<Tag, Affine.Discrete.Vector> {
    Tagged<Tag, Affine.Discrete.Vector>(__unchecked: (), -v.rawValue)
}

// MARK: - Compound Assignment for Ordinal ± Vector

/// Advances a tagged ordinal by a tagged vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func += <Tag: ~Copyable>(
    lhs: inout Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs + rhs
}

/// Retreats a tagged ordinal by a tagged vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func -= <Tag: ~Copyable>(
    lhs: inout Tagged<Tag, Ordinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs - rhs
}

// MARK: - Tagged<Tag, Vector> ↔ Tagged<Tag, Cardinal> Comparisons

/// Checks if a tagged vector is less than a tagged cardinal.
///
/// This compares a signed displacement to an unsigned magnitude.
/// Useful for bounds checking where negative vectors are always out of bounds.
@inlinable
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Affine.Discrete.Vector>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Vector < Cardinal
}

@inlinable
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Affine.Discrete.Vector>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Affine.Discrete.Vector>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Affine.Discrete.Vector>,
    rhs: Tagged<Tag, Cardinal>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

// Reverse direction

@inlinable
public func < <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) -> Bool {
    lhs.rawValue < rhs.rawValue  // Delegates to Cardinal < Vector
}

@inlinable
public func <= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

@inlinable
public func > <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) -> Bool {
    lhs.rawValue > rhs.rawValue
}

@inlinable
public func >= <Tag: ~Copyable>(
    lhs: Tagged<Tag, Cardinal>,
    rhs: Tagged<Tag, Affine.Discrete.Vector>
) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

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
    let result = Int(lhs.rawValue.rawValue) * rhs.factor
    precondition(result >= 0, "Scaled cardinal must be non-negative")
    return Tagged<To, Cardinal>(__unchecked: (), Cardinal(UInt(result)))
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
    Tagged<To, Affine.Discrete.Vector>(__unchecked: (), Affine.Discrete.Vector(lhs.rawValue.rawValue * rhs.factor))
}

/// Scales a tagged vector from one domain to another (commutative).
@inlinable
public func * <From: ~Copyable, To: ~Copyable>(
    lhs: Affine.Discrete.Ratio<From, To>,
    rhs: Tagged<From, Affine.Discrete.Vector>
) -> Tagged<To, Affine.Discrete.Vector> {
    rhs * lhs
}
