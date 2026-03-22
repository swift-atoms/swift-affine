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
internal import Cardinal_Primitives

// MARK: - Position + Vector → Position (Point + Vector → Point)

/// Advances a position by a vector.
///
/// Generic over both `Ordinal.Protocol` and `Affine.Discrete.Vector.Protocol`,
/// so this single definition handles bare types and their `Tagged` wrappers.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: O,
    rhs: some Affine.Discrete.Vector.`Protocol`
) throws(Ordinal.Error) -> O {
    if rhs.vector.rawValue >= 0 {
        let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(UInt(rhs.vector.rawValue))
        guard !overflow else { throw .overflow }
        return O(Ordinal(result))
    } else {
        let magnitude = rhs.vector.rawValue.magnitude
        guard lhs.ordinal.rawValue >= magnitude else { throw .underflow }
        return O(Ordinal(lhs.ordinal.rawValue - magnitude))
    }
}

/// Advances a position by a vector (commutative).
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: some Affine.Discrete.Vector.`Protocol`,
    rhs: O
) throws(Ordinal.Error) -> O {
    try rhs + lhs
}

// MARK: - Position - Vector → Position (Point - Vector → Point)

/// Retreats a position by a vector.
///
/// Generic over both `Ordinal.Protocol` and `Affine.Discrete.Vector.Protocol`,
/// so this single definition handles bare types and their `Tagged` wrappers.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func - <O: Ordinal.`Protocol`>(
    lhs: O,
    rhs: some Affine.Discrete.Vector.`Protocol`
) throws(Ordinal.Error) -> O {
    if rhs.vector.rawValue <= 0 {
        let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(rhs.vector.rawValue.magnitude)
        guard !overflow else { throw .overflow }
        return O(Ordinal(result))
    } else {
        let magnitude = UInt(rhs.vector.rawValue)
        guard lhs.ordinal.rawValue >= magnitude else { throw .underflow }
        return O(Ordinal(lhs.ordinal.rawValue - magnitude))
    }
}

// MARK: - Position - Position → Vector (Point - Point → Vector)

/// Returns the signed vector between two positions.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
/// This is the fundamental affine operation: point difference yields a vector.
///
/// - Throws: `Affine.Discrete.Vector.Error.unrepresentable` if the difference exceeds
///   the representable range of `Int` (positions more than ~9.2 quintillion apart).
@inlinable
public func - (
    lhs: some Ordinal.`Protocol`,
    rhs: some Ordinal.`Protocol`
) throws(Affine.Discrete.Vector.Error) -> Affine.Discrete.Vector {
    if lhs.ordinal.rawValue >= rhs.ordinal.rawValue {
        let difference = lhs.ordinal.rawValue - rhs.ordinal.rawValue
        guard difference <= UInt(Int.max) else { throw .unrepresentable }
        return Affine.Discrete.Vector(Int(difference))
    } else {
        let difference = rhs.ordinal.rawValue - lhs.ordinal.rawValue
        // Int.min.magnitude == UInt(Int.max) + 1
        guard difference <= UInt(Int.max) + 1 else { throw .unrepresentable }
        if difference == UInt(Int.max) + 1 {
            return Affine.Discrete.Vector(Int.min)
        }
        return Affine.Discrete.Vector(-Int(difference))
    }
}

// MARK: - Compound Assignment for Ordinal ± Vector

/// Advances an ordinal by a vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func += <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Affine.Discrete.Vector.`Protocol`
) throws(Ordinal.Error) {
    lhs = try lhs + rhs
}

/// Retreats an ordinal by a vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func -= <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Affine.Discrete.Vector.`Protocol`
) throws(Ordinal.Error) {
    lhs = try lhs - rhs
}

// MARK: - Vector ↔ Count Comparisons

/// Cross-type comparisons between vectors and cardinals.
///
/// Generic over both `Affine.Discrete.Vector.Protocol` and `Cardinal.Protocol`
/// with `V.Domain == C.Domain`, so a single definition handles:
/// - Bare: `Affine.Discrete.Vector` ↔ `Cardinal` (Domain = Never)
/// - Tagged: `Tagged<Tag, Vector>` ↔ `Tagged<Tag, Cardinal>` (Domain = Tag)
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal < Cardinal, Vector < Vector) are preferred during type inference.
/// This prevents ambiguity when using integer literals.

@inlinable
@_disfavoredOverload
public func < <V: Affine.Discrete.Vector.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: V, rhs: C
) -> Bool where V.Domain == C.Domain {
    lhs.vector.rawValue < Int(rhs.cardinal.rawValue)
}

@inlinable
@_disfavoredOverload
public func <= <V: Affine.Discrete.Vector.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: V, rhs: C
) -> Bool where V.Domain == C.Domain {
    lhs.vector.rawValue <= Int(rhs.cardinal.rawValue)
}

@inlinable
@_disfavoredOverload
public func > <V: Affine.Discrete.Vector.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: V, rhs: C
) -> Bool where V.Domain == C.Domain {
    lhs.vector.rawValue > Int(rhs.cardinal.rawValue)
}

@inlinable
@_disfavoredOverload
public func >= <V: Affine.Discrete.Vector.`Protocol`, C: Cardinal.`Protocol`>(
    lhs: V, rhs: C
) -> Bool where V.Domain == C.Domain {
    lhs.vector.rawValue >= Int(rhs.cardinal.rawValue)
}

// Reverse direction (Cardinal ↔ Vector)

@inlinable
@_disfavoredOverload
public func < <C: Cardinal.`Protocol`, V: Affine.Discrete.Vector.`Protocol`>(
    lhs: C, rhs: V
) -> Bool where C.Domain == V.Domain {
    Int(lhs.cardinal.rawValue) < rhs.vector.rawValue
}

@inlinable
@_disfavoredOverload
public func <= <C: Cardinal.`Protocol`, V: Affine.Discrete.Vector.`Protocol`>(
    lhs: C, rhs: V
) -> Bool where C.Domain == V.Domain {
    Int(lhs.cardinal.rawValue) <= rhs.vector.rawValue
}

@inlinable
@_disfavoredOverload
public func > <C: Cardinal.`Protocol`, V: Affine.Discrete.Vector.`Protocol`>(
    lhs: C, rhs: V
) -> Bool where C.Domain == V.Domain {
    Int(lhs.cardinal.rawValue) > rhs.vector.rawValue
}

@inlinable
@_disfavoredOverload
public func >= <C: Cardinal.`Protocol`, V: Affine.Discrete.Vector.`Protocol`>(
    lhs: C, rhs: V
) -> Bool where C.Domain == V.Domain {
    Int(lhs.cardinal.rawValue) >= rhs.vector.rawValue
}
