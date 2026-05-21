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

// MARK: - UnsafeMutableRawPointer + Carrier.`Protocol`<Affine.Discrete.Vector>

extension UnsafeMutableRawPointer {
    /// Returns a mutable raw pointer advanced by the given signed typed-Vector byte offset.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `UnsafeMutableRawPointer.advanced(by: Int) -> Self`. Accepts any
    /// `Carrier.`Protocol`<Affine.Discrete.Vector>` conformer (signed
    /// displacement), removing the `Int(bitPattern:)` dance at the call site.
    ///
    /// - Parameter offset: The signed typed-Vector byte offset to advance by.
    /// - Returns: A mutable raw pointer offset from this pointer by `offset` bytes.
    @inlinable
    public func advanced(by offset: some Carrier.`Protocol`<Affine.Discrete.Vector>) -> Self {
        unsafe self.advanced(by: Int(bitPattern: offset.underlying))
    }

    /// Loads a value of the given type from this pointer at a signed typed-Vector byte offset.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `UnsafeMutableRawPointer.load(fromByteOffset: Int, as:)`.
    ///
    /// - Parameters:
    ///   - offset: The signed typed-Vector byte offset to load from.
    ///   - type: The type of value to load.
    /// - Returns: The value loaded from the specified offset.
    @inlinable
    public func load<T>(
        fromByteOffset offset: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        as type: T.Type
    ) -> T {
        unsafe self.load(
            fromByteOffset: Int(bitPattern: offset.underlying),
            as: type
        )
    }

    /// Stores the bytes of a value at this pointer at a signed typed-Vector byte offset.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `UnsafeMutableRawPointer.storeBytes(of:toByteOffset: Int, as:)`.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - offset: The signed typed-Vector byte offset to store to.
    ///   - type: The type of value being stored.
    @inlinable
    public func storeBytes<T>(
        of value: T,
        toByteOffset offset: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        as type: T.Type
    ) {
        unsafe self.storeBytes(
            of: value,
            toByteOffset: Int(bitPattern: offset.underlying),
            as: type
        )
    }
}
