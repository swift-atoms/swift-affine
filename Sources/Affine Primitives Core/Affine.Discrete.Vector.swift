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
    /// A signed vector (displacement) in discrete affine space.
    ///
    /// `Vector` represents the directed distance between two positions.
    /// Positive values indicate forward movement (toward higher positions),
    /// negative values indicate backward movement.
    ///
    /// ## Semantic Model
    ///
    /// In affine geometry, vectors are the result of subtracting two points:
    /// - `position2 - position1 → vector`
    /// - `position1 + vector → position2`
    ///
    /// Vectors form a group under addition (can be combined, negated,
    /// have identity 0), while positions do not (no negative positions).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let forward: Affine.Discrete.Vector = 5
    /// let backward: Affine.Discrete.Vector = -3
    /// let combined = forward + backward  // Vector(2)
    /// ```
    public struct Vector: Hashable, Comparable, Sendable {
        /// The underlying signed value.
        public let rawValue: Int

        /// Creates a vector with the given signed value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The zero vector.
        @inlinable
        public static var zero: Self { Self(0) }
        
        /// The zero vector.
        @inlinable
        public static var one: Self { Self(1) }

        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }

        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }

        @inlinable
        public static func <= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue <= rhs.rawValue
        }

        @inlinable
        public static func > (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue > rhs.rawValue
        }

        @inlinable
        public static func >= (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue >= rhs.rawValue
        }

        /// The absolute value of this displacement as a cardinal quantity.
        ///
        /// Maps ℤ → ℕ: the magnitude of a vector is the unsigned distance
        /// it represents, stripping direction information.
        @inlinable
        public var magnitude: Cardinal {
            Cardinal(rawValue.magnitude)
        }
    }

    /// Legacy typealias for migration.
    @available(*, deprecated, renamed: "Vector")
    public typealias Displacement = Vector
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Vector: CustomStringConvertible {
    public var description: String {
        "Vector(\(rawValue))"
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Affine.Discrete.Vector: ExpressibleByIntegerLiteral {
    @inlinable
    @_disfavoredOverload
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

// MARK: - Equation.Protocol, Comparison.Protocol

extension Affine.Discrete.Vector: Equation.`Protocol` {}
extension Affine.Discrete.Vector: Comparison.`Protocol` {}
