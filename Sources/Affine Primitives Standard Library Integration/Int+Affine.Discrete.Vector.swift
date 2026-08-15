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

public import Carrier_Primitives

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
    public init<Tag: ~Copyable & ~Escapable>(bitPattern offset: Tagged<Tag, Affine.Discrete.Vector>)
    {
        self.init(bitPattern: offset.underlying)
    }

    /// Creates an integer from any `Carrier.`Protocol`<Affine.Discrete.Vector>` conformer.
    ///
    /// Generic typed-Vector overload covering bare `Affine.Discrete.Vector`
    /// AND phantom-typed `Tagged<Tag, Affine.Discrete.Vector>` (including
    /// `Tagged<T, Ordinal>.Offset`, `Memory.Address.Offset`, etc.) without
    /// requiring callers to unwrap via `.vector` / `.underlying` accessor
    /// chains at the call site.
    ///
    /// - Parameter carrier: Any conformer to `Carrier.`Protocol`<Affine.Discrete.Vector>`.
    @inlinable
    public init(bitPattern carrier: some Carrier.`Protocol`<Affine.Discrete.Vector>) {
        self.init(bitPattern: carrier.underlying)
    }
}
