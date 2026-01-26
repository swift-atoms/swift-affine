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
    /// A signed displacement between positions in discrete affine space.
    ///
    /// `Displacement` represents the directed distance between two positions.
    /// Positive values indicate forward movement (toward higher positions),
    /// negative values indicate backward movement.
    ///
    /// ## Semantic Model
    ///
    /// A displacement is the result of subtracting two positions:
    /// - `position2 - position1 → displacement`
    /// - `position1 + displacement → position2`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let forward: Affine.Discrete.Displacement = 5
    /// let backward: Affine.Discrete.Displacement = -3
    /// let combined = forward + backward  // Displacement(2)
    /// ```
    public struct Displacement: Hashable, Comparable, Sendable {
        /// The underlying signed value.
        public let rawValue: Int

        /// Creates a displacement with the given signed value.
        @inlinable
        public init(_ rawValue: Int) {
            self.rawValue = rawValue
        }

        
        @inlinable
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: - CustomStringConvertible

extension Affine.Discrete.Displacement: CustomStringConvertible {
    public var description: String {
        "Displacement(\(rawValue))"
    }
}
