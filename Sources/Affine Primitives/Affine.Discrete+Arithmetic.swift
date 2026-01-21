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

// MARK: - Position + Displacement → Position? (Point + Vector → Point)

/// Advances a position by a displacement.
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func + (
    lhs: Affine.Discrete.Position,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Position? {
    let result = lhs.rawValue + rhs.rawValue
    guard result >= 0 else { return nil }
    return Affine.Discrete.Position(__unchecked: result)
}

/// Advances a position by a displacement (commutative).
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func + (
    lhs: Affine.Discrete.Displacement,
    rhs: Affine.Discrete.Position
) -> Affine.Discrete.Position? {
    let result = lhs.rawValue + rhs.rawValue
    guard result >= 0 else { return nil }
    return Affine.Discrete.Position(__unchecked: result)
}

// MARK: - Position - Displacement → Position? (Point - Vector → Point)

/// Retreats a position by a displacement.
///
/// - Returns: The new position, or `nil` if the result would be negative.
@inlinable
public func - (
    lhs: Affine.Discrete.Position,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Position? {
    let result = lhs.rawValue - rhs.rawValue
    guard result >= 0 else { return nil }
    return Affine.Discrete.Position(__unchecked: result)
}

// MARK: - Position - Position → Displacement (Point - Point → Vector)

/// Returns the signed displacement between two positions.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
/// This is the fundamental affine operation: point difference yields a vector.
@inlinable
public func - (
    lhs: Affine.Discrete.Position,
    rhs: Affine.Discrete.Position
) -> Affine.Discrete.Displacement {
    Affine.Discrete.Displacement(lhs.rawValue - rhs.rawValue)
}

// MARK: - Displacement ± Displacement → Displacement (Vector ± Vector → Vector)

/// Adds two displacements.
@inlinable
public func + (
    lhs: Affine.Discrete.Displacement,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Displacement {
    Affine.Discrete.Displacement(lhs.rawValue + rhs.rawValue)
}

/// Subtracts two displacements.
@inlinable
public func - (
    lhs: Affine.Discrete.Displacement,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Displacement {
    Affine.Discrete.Displacement(lhs.rawValue - rhs.rawValue)
}

/// Negates a displacement.
@inlinable
public prefix func - (d: Affine.Discrete.Displacement) -> Affine.Discrete.Displacement {
    Affine.Discrete.Displacement(-d.rawValue)
}
