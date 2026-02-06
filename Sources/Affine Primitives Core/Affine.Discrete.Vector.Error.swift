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

extension Affine.Discrete.Vector {
    /// Errors that can occur during vector operations.
    public enum Error: Swift.Error, Hashable, Sendable {
        /// The difference between positions exceeds the representable range of `Int`.
        ///
        /// Thrown when computing `position1 - position2` where the positions are
        /// more than `Int.max` apart (approximately 9.2 quintillion).
        case unrepresentable
    }
}
