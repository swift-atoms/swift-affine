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
public import Ordinal_Primitives

extension Ordinal {
    /// Creates an ordinal from a non-negative vector.
    ///
    /// This initializer is the partial inverse of `Affine.Discrete.Vector.init(_ ordinal:)`,
    /// mapping ℤ⁺ → ℕ by restricting to non-negative displacements.
    /// Negative vectors have no corresponding ordinal position.
    ///
    /// - Throws: `Ordinal.Error.negativeSource` if the vector is negative.
    @inlinable
    public init(_ vector: Affine.Discrete.Vector) throws(Ordinal.Error) {
        guard vector.rawValue >= 0 else {
            throw .negativeSource(vector.rawValue)
        }
        self.init(UInt(vector.rawValue))
    }
}
