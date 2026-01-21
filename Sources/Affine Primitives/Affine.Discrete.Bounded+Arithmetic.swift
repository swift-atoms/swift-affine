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

// MARK: - Bounded + Displacement → Bounded? (Point + Vector → Point)

/// Advances a bounded position by a displacement.
///
/// - Returns: The new bounded position, or `nil` if out of bounds.
@inlinable
public func + <let N: Int>(
    lhs: Affine.Discrete.Bounded<N>,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Bounded<N>? {
    let result = lhs.rawValue + rhs.rawValue
    guard result >= 0, result < N else { return nil }
    return Affine.Discrete.Bounded<N>(__unchecked: result)
}

/// Advances a bounded position by a displacement (commutative).
///
/// - Returns: The new bounded position, or `nil` if out of bounds.
@inlinable
public func + <let N: Int>(
    lhs: Affine.Discrete.Displacement,
    rhs: Affine.Discrete.Bounded<N>
) -> Affine.Discrete.Bounded<N>? {
    let result = lhs.rawValue + rhs.rawValue
    guard result >= 0, result < N else { return nil }
    return Affine.Discrete.Bounded<N>(__unchecked: result)
}

// MARK: - Bounded - Displacement → Bounded? (Point - Vector → Point)

/// Retreats a bounded position by a displacement.
///
/// - Returns: The new bounded position, or `nil` if out of bounds.
@inlinable
public func - <let N: Int>(
    lhs: Affine.Discrete.Bounded<N>,
    rhs: Affine.Discrete.Displacement
) -> Affine.Discrete.Bounded<N>? {
    let result = lhs.rawValue - rhs.rawValue
    guard result >= 0, result < N else { return nil }
    return Affine.Discrete.Bounded<N>(__unchecked: result)
}

// MARK: - Bounded - Bounded → Displacement (Point - Point → Vector)

/// Returns the signed displacement between two bounded positions.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
@inlinable
public func - <let N: Int>(
    lhs: Affine.Discrete.Bounded<N>,
    rhs: Affine.Discrete.Bounded<N>
) -> Affine.Discrete.Displacement {
    Affine.Discrete.Displacement(lhs.rawValue - rhs.rawValue)
}
