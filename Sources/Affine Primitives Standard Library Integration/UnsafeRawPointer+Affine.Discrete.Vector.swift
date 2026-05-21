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

// MARK: - UnsafeRawPointer + Carrier.`Protocol`<Affine.Discrete.Vector>
//
// Companion to the Ordinal-typed `advanced(by:)` / `load(fromByteOffset:as:)`
// overloads in swift-ordinal-primitives. Ordinal-typed forms accept only
// non-negative positions; Vector-typed forms accept signed displacement,
// matching stdlib's `Int`-typed parameters which are themselves signed.

extension UnsafeRawPointer {
    /// Returns a raw pointer advanced by the given signed typed-Vector byte offset.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `UnsafeRawPointer.advanced(by: Int) -> Self`. Accepts any
    /// `Carrier.`Protocol`<Affine.Discrete.Vector>` conformer (bare
    /// `Affine.Discrete.Vector` or phantom-typed
    /// `Tagged<Tag, Affine.Discrete.Vector>`), removing the
    /// `Int(bitPattern:)` dance at the call site.
    ///
    /// Companion to the Ordinal-typed `advanced(by: some Ordinal.\`Protocol\`)`
    /// overload (non-negative); use this form when the displacement is
    /// signed.
    ///
    /// - Parameter offset: The signed typed-Vector byte offset to advance by.
    /// - Returns: A raw pointer offset from this pointer by `offset` bytes.
    @inlinable
    public func advanced(by offset: some Carrier.`Protocol`<Affine.Discrete.Vector>) -> Self {
        unsafe self.advanced(by: Int(bitPattern: offset.underlying))
    }

    /// Loads a value of the given type from this pointer at a signed typed-Vector byte offset.
    ///
    /// Typed-Vector overload mirroring stdlib's
    /// `UnsafeRawPointer.load(fromByteOffset: Int, as:)`.
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
}
