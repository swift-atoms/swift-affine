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

public import Carrier_Primitives

// MARK: - Collection + Carrier.`Protocol`<Affine.Discrete.Vector>

extension Collection {
    /// Returns an index that is the specified typed-Vector offset from the given index.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `Collection.index(_:offsetBy:Int) -> Self.Index`. Accepts any
    /// `Carrier.`Protocol`<Affine.Discrete.Vector>` conformer (bare
    /// `Affine.Discrete.Vector` or phantom-typed
    /// `Tagged<Tag, Affine.Discrete.Vector>` / `Tagged<Tag, Ordinal>.Offset`),
    /// removing the `Int(bitPattern:)` dance at the call site.
    ///
    /// Placed on `Collection` (the protocol-level home for `index(_:offsetBy:)`)
    /// so the overload covers `Array`, `ArraySlice`, `ContiguousArray`,
    /// `String`, and any other `Collection` conformer with one declaration.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The signed typed-Vector distance to offset `i` by.
    /// - Returns: An index offset by `distance` from `i`.
    /// - Precondition: The resulting index must be valid for the collection.
    /// - Complexity: O(1) on a `RandomAccessCollection`; otherwise O(`abs(distance)`).
    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>
    ) -> Self.Index {
        self.index(i, offsetBy: Int(bitPattern: distance.underlying))
    }

    /// Returns an index that is the specified typed-Vector offset from the
    /// given index, unless it would exceed the specified limit.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `Collection.index(_:offsetBy:Int, limitedBy:Self.Index) -> Self.Index?`.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The signed typed-Vector distance to offset `i` by.
    ///   - limit: A valid index of the collection to use as a limit.
    /// - Returns: An index offset by `distance` from `i`, or `nil` if the
    ///   offset would exceed `limit`.
    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        limitedBy limit: Self.Index
    ) -> Self.Index? {
        self.index(i, offsetBy: Int(bitPattern: distance.underlying), limitedBy: limit)
    }

    /// Offsets the given index by the specified typed-Vector distance.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `Collection.formIndex(_: inout Self.Index, offsetBy: Int)`.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The signed typed-Vector distance to offset `i` by.
    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>
    ) {
        self.formIndex(&i, offsetBy: Int(bitPattern: distance.underlying))
    }

    /// Offsets the given index by the specified typed-Vector distance, or so
    /// that it equals the given limiting index.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `Collection.formIndex(_: inout Self.Index, offsetBy: Int, limitedBy: Self.Index) -> Bool`.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The signed typed-Vector distance to offset `i` by.
    ///   - limit: A valid index of the collection to use as a limit.
    /// - Returns: `true` if `i` was offset by `distance` without exceeding
    ///   `limit`; otherwise, `false` and `i` is set to `limit`.
    @discardableResult
    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        limitedBy limit: Self.Index
    ) -> Bool {
        self.formIndex(&i, offsetBy: Int(bitPattern: distance.underlying), limitedBy: limit)
    }
}
