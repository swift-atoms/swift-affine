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

// MARK: - Position + Vector → Position (Point + Vector → Point)

/// Advances a position by a vector.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + (
    lhs: Ordinal,
    rhs: Affine.Discrete.Vector
) throws(Ordinal.Error) -> Ordinal {
    if rhs.rawValue >= 0 {
        let (result, overflow) = lhs.rawValue.addingReportingOverflow(UInt(rhs.rawValue))
        guard !overflow else { throw .overflow }
        return Ordinal(result)
    } else {
        let magnitude = rhs.rawValue.magnitude
        guard lhs.rawValue >= magnitude else { throw .underflow }
        return Ordinal(lhs.rawValue - magnitude)
    }
}

/// Advances a position by a vector (commutative).
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + (
    lhs: Affine.Discrete.Vector,
    rhs: Ordinal
) throws(Ordinal.Error) -> Ordinal {
    try rhs + lhs
}

// MARK: - Position - Vector → Position (Point - Vector → Point)

/// Retreats a position by a vector.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func - (
    lhs: Ordinal,
    rhs: Affine.Discrete.Vector
) throws(Ordinal.Error) -> Ordinal {
    if rhs.rawValue <= 0 {
        let (result, overflow) = lhs.rawValue.addingReportingOverflow(rhs.rawValue.magnitude)
        guard !overflow else { throw .overflow }
        return Ordinal(result)
    } else {
        let magnitude = UInt(rhs.rawValue)
        guard lhs.rawValue >= magnitude else { throw .underflow }
        return Ordinal(lhs.rawValue - magnitude)
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
    lhs: Ordinal,
    rhs: Ordinal
) throws(Affine.Discrete.Vector.Error) -> Affine.Discrete.Vector {
    if lhs.rawValue >= rhs.rawValue {
        let difference = lhs.rawValue - rhs.rawValue
        guard difference <= UInt(Int.max) else { throw .unrepresentable }
        return Affine.Discrete.Vector(Int(difference))
    } else {
        let difference = rhs.rawValue - lhs.rawValue
        // Int.min.magnitude == UInt(Int.max) + 1
        guard difference <= UInt(Int.max) + 1 else { throw .unrepresentable }
        if difference == UInt(Int.max) + 1 {
            return Affine.Discrete.Vector(Int.min)
        }
        return Affine.Discrete.Vector(-Int(difference))
    }
}

// MARK: - Vector ± Vector → Vector (Vector ± Vector → Vector)

/// Adds two vectors.
@inlinable
public func + (
    lhs: Affine.Discrete.Vector,
    rhs: Affine.Discrete.Vector
) -> Affine.Discrete.Vector {
    Affine.Discrete.Vector(lhs.rawValue + rhs.rawValue)
}

/// Subtracts two vectors.
@inlinable
public func - (
    lhs: Affine.Discrete.Vector,
    rhs: Affine.Discrete.Vector
) -> Affine.Discrete.Vector {
    Affine.Discrete.Vector(lhs.rawValue - rhs.rawValue)
}

/// Negates a vector.
@inlinable
public prefix func - (v: Affine.Discrete.Vector) -> Affine.Discrete.Vector {
    Affine.Discrete.Vector(-v.rawValue)
}

// MARK: - Compound Assignment

/// Adds a vector to another vector in place.
@inlinable
public func += (lhs: inout Affine.Discrete.Vector, rhs: Affine.Discrete.Vector) {
    lhs = lhs + rhs
}

/// Subtracts a vector from another vector in place.
@inlinable
public func -= (lhs: inout Affine.Discrete.Vector, rhs: Affine.Discrete.Vector) {
    lhs = lhs - rhs
}

// MARK: - Vector ↔ Count Comparisons

/// Cross-type comparisons between vectors and cardinals.
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal < Cardinal, Vector < Vector) are preferred during type inference.
/// This prevents ambiguity when using integer literals.

@inlinable
@_disfavoredOverload
public func < (lhs: Affine.Discrete.Vector, rhs: Cardinal) -> Bool {
    lhs.rawValue < Int(rhs.rawValue)
}

@inlinable
@_disfavoredOverload
public func <= (lhs: Affine.Discrete.Vector, rhs: Cardinal) -> Bool {
    lhs.rawValue <= Int(rhs.rawValue)
}

@inlinable
@_disfavoredOverload
public func > (lhs: Affine.Discrete.Vector, rhs: Cardinal) -> Bool {
    lhs.rawValue > Int(rhs.rawValue)
}

@inlinable
@_disfavoredOverload
public func >= (lhs: Affine.Discrete.Vector, rhs: Cardinal) -> Bool {
    lhs.rawValue >= Int(rhs.rawValue)
}

// Reverse direction (Cardinal ↔ Vector)

@inlinable
@_disfavoredOverload
public func < (lhs: Cardinal, rhs: Affine.Discrete.Vector) -> Bool {
    Int(lhs.rawValue) < rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func <= (lhs: Cardinal, rhs: Affine.Discrete.Vector) -> Bool {
    Int(lhs.rawValue) <= rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func > (lhs: Cardinal, rhs: Affine.Discrete.Vector) -> Bool {
    Int(lhs.rawValue) > rhs.rawValue
}

@inlinable
@_disfavoredOverload
public func >= (lhs: Cardinal, rhs: Affine.Discrete.Vector) -> Bool {
    Int(lhs.rawValue) >= rhs.rawValue
}
