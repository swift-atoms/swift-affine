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

extension Affine.Discrete.Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {
    /// Errors that can occur when dividing a typed count or position by a ratio's factor.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The ratio's factor is zero; division is undefined.
        ///
        /// Thrown by `quotientAndRemainder(dividing:)` when `factor == 0`.
        case zeroFactor

        /// The ratio's factor is negative.
        ///
        /// A negative factor applied to a non-negative dividend produces a
        /// mathematically negative quotient, which cannot be represented by
        /// the unsigned `Cardinal`/`Ordinal` result type.
        ///
        /// Thrown by `quotientAndRemainder(dividing:)` when `factor < 0`.
        /// - Parameter factor: The negative factor that was provided.
        case negativeFactor(Int)

        /// The dividend exceeds `Int.max` and cannot be represented as a
        /// signed `Int` for the division.
        ///
        /// Thrown by `quotientAndRemainder(dividing:)` when the count or
        /// ordinal being divided has a raw value above `Int.max`.
        case unrepresentable
    }
}
