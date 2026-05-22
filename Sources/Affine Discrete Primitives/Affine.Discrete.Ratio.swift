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

extension Affine.Discrete {
    /// A multiplicative discrete morphism between typed domains.
    ///
    /// `Ratio<From, To>` represents a conversion factor that maps quantities
    /// (offsets, counts) from one domain to another. The factor is signed,
    /// allowing direction reversal.
    ///
    /// ## Mathematical Model
    ///
    /// A ratio is a morphism in the category of discrete affine spaces:
    /// - Identity: `Ratio<T, T>(1)` is the identity morphism
    /// - Composition: `Ratio<A,B> * Ratio<B,C> = Ratio<A,C>` with multiplied factors
    /// - Action: Ratios act on vectors (offsets/counts), not on points (indices)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bitsPerByte = Affine.Discrete.Ratio<UInt8, Bit>(8)
    /// let byteOffset: Index<Memory>.Offset = Index<Memory>.Offset(2)
    /// let bitOffset = byteOffset * bitsPerByte  // Index<Bit>.Offset with value 16
    /// ```
    ///
    /// ## Type Safety
    ///
    /// The type system prevents invalid operations:
    /// - `Offset<A> * Ratio<A,B>` → compiles, returns `Offset<B>`
    /// - `Offset<A> * Ratio<B,C>` → compile error (domain mismatch)
    /// - `Index<A> * Ratio<A,B>` → compile error (position scaling undefined)
    ///
    /// ## See Also
    ///
    /// - ``Vector`` for discrete displacements
    /// - [Discrete Scaling Morphisms](swift-institute/Research/discrete-scaling-morphisms.md)
    public struct Ratio<From: ~Copyable, To: ~Copyable>: Hashable, Sendable {
        /// The conversion factor (signed, allows direction reversal).
        public let factor: Int

        /// Creates a ratio with the given factor.
        ///
        /// - Parameter factor: The multiplicative conversion factor.
        @inlinable
        public init(_ factor: Int) {
            self.factor = factor
        }
    }
}

// MARK: - Same-Domain (Endomorphism) Operations

extension Affine.Discrete.Ratio where From == To, From: ~Copyable {
    /// The identity ratio (factor = 1).
    ///
    /// The identity ratio leaves quantities unchanged:
    /// `offset * .identity == offset`
    @inlinable
    public static var identity: Self {
        Self(1)
    }

    /// The negation ratio (factor = -1).
    ///
    /// Reverses direction without changing magnitude.
    @inlinable
    public static var negate: Self {
        Self(-1)
    }
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Ratio: CustomStringConvertible where From: ~Copyable, To: ~Copyable {
    /// A textual representation of this ratio (e.g., `Ratio<UInt8, Bit>(8)`).
    public var description: String {
        "Ratio<\(From.self), \(To.self)>(\(factor))"
    }
}

// MARK: - ExpressibleByIntegerLiteral (same-domain only)

extension Affine.Discrete.Ratio: ExpressibleByIntegerLiteral where From == To, From: ~Copyable {
    /// Creates a same-domain ratio from an integer literal.
    @_disfavoredOverload
    @inlinable
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
