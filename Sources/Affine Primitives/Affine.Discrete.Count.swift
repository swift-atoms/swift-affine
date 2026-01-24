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

public import Equation_Primitives
public import Comparison_Primitives

extension Affine.Discrete {
    /// The cardinality (size) of a discrete range.
    ///
    /// `Count` represents "how many" elements exist, distinct from `Position` ("where").
    /// The primary use is bounds checking: `position < count`.
    ///
    /// ## Semantic Model
    ///
    /// In the affine space model:
    /// - `Position`: where (a point)
    /// - `Displacement`: how far (a vector)
    /// - `Count`: how many (cardinality)
    ///
    /// For a range `0..<N`:
    /// - Valid positions are `0, 1, ..., N-1`
    /// - Count is `N`
    /// - `position < count` is the bounds check
    ///
    /// ## Example
    ///
    /// ```swift
    /// let count: Affine.Discrete.Count = 10
    /// let position = try Affine.Discrete.Position(5)
    ///
    /// if position < count {
    ///     // position is valid for a collection of this size
    /// }
    /// ```
    public struct Count: Hashable, Comparable, Sendable {
        /// The underlying non-negative value.
        public let rawValue: Int

        /// Creates a count from a raw value.
        ///
        /// - Parameter rawValue: The count value. Must be non-negative.
        /// - Throws: `Error.negativeValue` if `rawValue < 0`.
        @inlinable
        public init(_ rawValue: Int) throws(Error) {
            guard rawValue >= 0 else { throw .negativeValue(rawValue) }
            self.rawValue = rawValue
        }

        /// Creates a count without validation.
        ///
        /// - Parameter rawValue: Must be non-negative.
        /// - Warning: No validation is performed. Use only when the value
        ///   is known to be non-negative.
        @inlinable
        public init(__unchecked rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The zero count.
        @inlinable
        public static var zero: Self {
            Self(__unchecked: 0)
        }
        
        /// The zero count.
        @inlinable
        public static var one: Self {
            Self(__unchecked: 1)
        }
        
        /// The zero count.
        @inlinable
        public static var two: Self {
            Self(__unchecked: 2)
        }

        // Explicit == for Equatable/Equation.Protocol compatibility.
        @inlinable
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue == rhs.rawValue
        }

        // All comparison operators defined explicitly to avoid conflicts between
        // Swift.Comparable defaults and Comparison.Protocol defaults.
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
    }
}

// MARK: - Count.Error

extension Affine.Discrete.Count {
    /// Error thrown when count construction fails.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The provided value was negative.
        case negativeValue(Int)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Affine.Discrete.Count: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        precondition(value >= 0, "Count literal cannot be negative")
        self.rawValue = value
    }
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Count: CustomStringConvertible {
    public var description: String {
        "Count(\(rawValue))"
    }
}

// MARK: - Arithmetic

extension Affine.Discrete.Count {
    /// Adds two counts.
    ///
    /// Result is guaranteed non-negative since both operands are.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(__unchecked: lhs.rawValue + rhs.rawValue)
    }

    /// Subtracts one count from another.
    ///
    /// - Returns: The difference, or `nil` if the result would be negative.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self? {
        let result = lhs.rawValue - rhs.rawValue
        guard result >= 0 else { return nil }
        return Self(__unchecked: result)
    }
}

// MARK: - Position < Count Comparison

/// Checks if a position is within bounds for a collection of the given count.
///
/// This is the fundamental bounds check: `position < count` means the position
/// is valid for a collection with `count` elements (positions `0..<count`).
@inlinable
public func < (lhs: Affine.Discrete.Position, rhs: Affine.Discrete.Count) -> Bool {
    lhs.rawValue < rhs.rawValue
}

/// Checks if a position is at or beyond the bounds for a collection of the given count.
@inlinable
public func >= (lhs: Affine.Discrete.Position, rhs: Affine.Discrete.Count) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

/// Checks if a count is greater than a position (position is in bounds).
@inlinable
public func > (lhs: Affine.Discrete.Count, rhs: Affine.Discrete.Position) -> Bool {
    lhs.rawValue > rhs.rawValue
}

/// Checks if a count is at or below a position (position is out of bounds).
@inlinable
public func <= (lhs: Affine.Discrete.Count, rhs: Affine.Discrete.Position) -> Bool {
    lhs.rawValue <= rhs.rawValue
}

// MARK: - Equation.Protocol, Comparison.Protocol

// Empty conformances work because all operators are defined explicitly above,
// avoiding conflicts between Swift.Comparable and Comparison.Protocol defaults.
extension Affine.Discrete.Count: Equation.`Protocol` {}
extension Affine.Discrete.Count: Comparison.`Protocol` {}
