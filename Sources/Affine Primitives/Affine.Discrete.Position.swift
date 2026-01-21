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
    /// A non-negative position in discrete affine space.
    ///
    /// `Position` represents a location on a discrete axis. Unlike raw integers:
    /// - Positions are non-negative (0, 1, 2, ...)
    /// - Positions represent **where**, not **how many**
    /// - Arithmetic on positions produces typed displacements, not more positions
    ///
    /// ## Affine Space Model
    ///
    /// Position follows affine space semantics:
    /// - `Position + Displacement → Position?` (translation)
    /// - `Position - Displacement → Position?` (translation)
    /// - `Position - Position → Displacement` (difference yields vector)
    /// - `Position + Position` is undefined (intentionally unsupported)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let p = try Affine.Discrete.Position(5)
    /// let d = Affine.Discrete.Displacement(3)
    /// let q = (p + d)!  // Position(8)
    /// let distance = q - p  // Displacement(3)
    /// ```
    public struct Position: Hashable, Comparable, Sendable {
        /// The underlying position value.
        public let rawValue: Int

        /// Creates a position at the given value.
        ///
        /// - Parameter rawValue: The position value. Must be non-negative.
        /// - Throws: `Error.negativeValue` if `rawValue < 0`.
        @inlinable
        public init(_ rawValue: Int) throws(Error) {
            guard rawValue >= 0 else { throw .negativeValue(rawValue) }
            self.rawValue = rawValue
        }

        /// Creates a position without validation.
        ///
        /// - Parameter rawValue: Must be non-negative.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be non-negative.
        @inlinable
        public init(__unchecked rawValue: Int) {
            self.rawValue = rawValue
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: - Position.Error

extension Affine.Discrete.Position {
    /// Error thrown when position construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The provided value was negative.
        case negativeValue(Int)
    }
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Position: CustomStringConvertible {
    public var description: String {
        "Position(\(rawValue))"
    }
}
