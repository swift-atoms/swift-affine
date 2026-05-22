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

public import Affine_Discrete_Primitives

// MARK: - Ratio Composition

/// Composes two ratios by multiplying their factors.
///
/// Composition is associative: `(r1 * r2) * r3 == r1 * (r2 * r3)`
///
/// ## Example
///
/// ```swift
/// let bitsPerByte = Ratio<UInt8, Bit>(8)
/// let bytesPerWord = Ratio<UInt64, UInt8>(8)
/// let bitsPerWord = bytesPerWord * bitsPerByte  // Ratio<UInt64, Bit>(64)
/// ```
///
/// - Parameters:
///   - lhs: A ratio from A to B.
///   - rhs: A ratio from B to C.
/// - Returns: A ratio from A to C with factor `lhs.factor * rhs.factor`.
@inlinable
public func * <A: ~Copyable, B: ~Copyable, C: ~Copyable>(
    lhs: Affine.Discrete.Ratio<A, B>,
    rhs: Affine.Discrete.Ratio<B, C>
) -> Affine.Discrete.Ratio<A, C> {
    Affine.Discrete.Ratio<A, C>(lhs.factor * rhs.factor)
}
