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
    /// A position bounded to the range `0..<N`.
    ///
    /// `Bounded<N>` is the canonical type with exactly N distinct values,
    /// indexed 0 through N-1. It represents a finite ordinal position
    /// suitable for compile-time bounded collection indices.
    ///
    /// ## Affine Space Model
    ///
    /// Like `Position`, bounded positions follow affine semantics:
    /// - `Bounded + Displacement → Bounded?` (nil if out of bounds)
    /// - `Bounded - Displacement → Bounded?` (nil if out of bounds)
    /// - `Bounded - Bounded → Displacement`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let index = try Affine.Discrete.Bounded<10>(5)
    /// let offset = Affine.Discrete.Displacement(3)
    /// let newIndex = (index + offset)!  // Bounded<10>(8)
    /// ```
    ///
    /// ## Integer Literals
    ///
    /// `Bounded` conforms to `ExpressibleByIntegerLiteral` for ergonomic usage.
    /// The literal initializer traps on invalid values (non-total by design):
    ///
    /// ```swift
    /// let valid: Bounded<5> = 3      // OK
    /// let invalid: Bounded<5> = 10   // Traps at runtime
    /// ```
    ///
    /// Use `try Bounded(value)` for validation that throws instead of trapping.
    public struct Bounded<let N: Int>: Hashable, Comparable, Sendable, ExpressibleByIntegerLiteral {
        /// The underlying position value (0 to N-1).
        public let rawValue: Int

        /// The number of valid positions.
        @inlinable
        public static var count: Int { N }

        /// Creates a bounded position from an integer.
        ///
        /// - Parameter rawValue: The position value.
        /// - Throws: `Error.outOfBounds` if `rawValue < 0` or `rawValue >= N`.
        @inlinable
        public init(_ rawValue: Int) throws(Error) {
            guard rawValue >= 0, rawValue < N else { throw .outOfBounds(rawValue) }
            self.rawValue = rawValue
        }

        /// Creates a bounded position without bounds checking.
        ///
        /// - Parameter rawValue: Must be in `0..<N`.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be in bounds.
        @inlinable
        public init(__unchecked rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Creates a bounded position from an integer literal.
        ///
        /// - Note: This initializer traps on invalid values. Use `try Bounded(value)`
        ///   for throwing validation.
        @inlinable
        public init(integerLiteral value: Int) {
            guard value >= 0, value < N else {
                preconditionFailure("Bounded literal \(value) out of bounds for Bounded<\(N)>")
            }
            self.rawValue = value
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: - Bounded.Error

extension Affine.Discrete.Bounded {
    /// Error thrown when bounded position construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The provided value was outside the valid range `0..<N`.
        case outOfBounds(Int)
    }
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Bounded: CustomStringConvertible {
    public var description: String {
        "Bounded<\(N)>(\(rawValue))"
    }
}

// MARK: - Conversion to Position

extension Affine.Discrete.Bounded {
    /// Converts this bounded position to an unbounded position.
    ///
    /// This conversion is always safe since bounded values are always non-negative.
    @inlinable
    public var position: Affine.Discrete.Position {
        Affine.Discrete.Position(__unchecked: rawValue)
    }
}
