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

// MARK: - Position + Vector → Position? (Point + Vector → Point)

/// Advances a position by a vector.
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func + (
    lhs: Ordinal.Position,
    rhs: Affine.Discrete.Vector
) -> Ordinal.Position? {
    let result = Int(bitPattern: lhs.rawValue) + rhs.rawValue
    guard result >= 0 else { return nil }
    return Ordinal.Position(UInt(result))
}

/// Advances a position by a vector (commutative).
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func + (
    lhs: Affine.Discrete.Vector,
    rhs: Ordinal.Position
) -> Ordinal.Position? {
    rhs + lhs
}

// MARK: - Position - Vector → Position? (Point - Vector → Point)

/// Retreats a position by a vector.
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func - (
    lhs: Ordinal.Position,
    rhs: Affine.Discrete.Vector
) -> Ordinal.Position? {
    let result = Int(bitPattern: lhs.rawValue) - rhs.rawValue
    guard result >= 0 else { return nil }
    return Ordinal.Position(UInt(result))
}

// MARK: - Position - Position → Vector (Point - Point → Vector)

/// Returns the signed vector between two positions.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
/// This is the fundamental affine operation: point difference yields a vector.
@inlinable
public func - (
    lhs: Ordinal.Position,
    rhs: Ordinal.Position
) -> Affine.Discrete.Vector {
    Affine.Discrete.Vector(Int(bitPattern: lhs.rawValue) - Int(bitPattern: rhs.rawValue))
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
