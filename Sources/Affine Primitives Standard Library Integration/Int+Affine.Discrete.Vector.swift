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

// MARK: - Vector to Int Conversions

extension Int {
    /// Creates an integer from a vector's raw value.
    ///
    /// This is a lossless conversion since `Vector` stores a signed `Int`.
    ///
    /// - Parameter vector: The affine discrete vector.
    @inlinable
    public init(bitPattern vector: Affine.Discrete.Vector) {
        self = vector.rawValue
    }

    /// Creates an integer from a tagged vector's raw value.
    ///
    /// Unwraps the phantom type tag and extracts the underlying signed value.
    ///
    /// - Parameter offset: The tagged affine discrete vector.
    @inlinable
    public init<Tag: ~Copyable>(bitPattern offset: Tagged<Tag, Affine.Discrete.Vector>) {
        self = offset.rawValue.rawValue
    }
}
