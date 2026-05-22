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

public import Cardinal_Primitives

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
    public struct Vector {
        /// The underlying signed value.
        public let rawValue: Int

        /// Creates a vector with the given signed value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    /// Legacy typealias for migration.
    @available(*, deprecated, renamed: "Vector")
    public typealias Displacement = Vector
}

// Stdlib `Hashable` / `Comparable` conformances on Swift <6.4 live in the
// Affine Hash Primitives + Affine Comparison Primitives sub-namespace targets
// (post-[MOD-031] split, 2026-05-22) so the explicit `hash(into:)` /
// `<` declarations satisfy the synthesis requirement at the same module.
// Pattern matches cardinal Wave 7 + ordinal Wave 8 split precedents.
extension Affine.Discrete.Vector: Sendable {}

extension Affine.Discrete.Vector {
    // MARK: - Equatable / Equation.Protocol

    /// Explicit equality for Equatable/Equation.Protocol compatibility.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    // MARK: - Comparable / Comparison.Protocol

    /// Returns `true` if `lhs` is less than `rhs`.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// Returns `true` if `lhs` is less than or equal to `rhs`.
    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue <= rhs.rawValue
    }

    /// Returns `true` if `lhs` is greater than `rhs`.
    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue > rhs.rawValue
    }

    /// Returns `true` if `lhs` is greater than or equal to `rhs`.
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

// MARK: - CustomStringConvertible

extension Affine.Discrete.Vector: CustomStringConvertible {
    /// A textual representation of this vector (e.g., `Vector(-3)`).
    public var description: String {
        "Vector(\(rawValue))"
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Affine.Discrete.Vector: ExpressibleByIntegerLiteral {
    /// Creates a vector from an integer literal.
    @inlinable
    @_disfavoredOverload
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}

// Institute-protocol conformances live in per-protocol files:
// - `Affine.Discrete.Vector+Equation.Protocol.swift`
// - `Affine.Discrete.Vector+Hash.Protocol.swift`
// - `Affine.Discrete.Vector+Comparison.Protocol.swift`
