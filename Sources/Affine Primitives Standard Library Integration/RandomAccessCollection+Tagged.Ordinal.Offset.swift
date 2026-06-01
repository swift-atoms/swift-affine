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

// MARK: - RandomAccessCollection + Tagged<T, Ordinal>.Offset

extension RandomAccessCollection {
    /// Returns an index that is the specified typed offset from the given index.
    ///
    /// This overload accepts a typed `Tagged<T, Ordinal>.Offset` for type-safe index arithmetic.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - offset: The typed offset to apply.
    /// - Returns: An index offset by `offset` from `i`.
    /// - Precondition: The resulting index must be valid.
    /// - Complexity: O(1).
    @inlinable
    public func index<T: ~Copyable & ~Escapable>(
        _ i: Index,
        offsetBy offset: Tagged<T, Ordinal>.Offset
    ) -> Index {
        index(i, offsetBy: offset.vector.rawValue)
    }
}
