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

// MARK: - UnsafePointer + Tagged<Pointee, Ordinal>.Offset Arithmetic
//
// Affine arithmetic: pointer (point) + offset (vector) = pointer (point)
// This is mathematically correct - we add a displacement to a position.

/// Advances a pointer by a typed element offset.
@_transparent
public func + <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafePointer<Pointee> {
    unsafe lhs.advanced(by: Int(bitPattern: rhs))
}

/// Advances a pointer by a typed element offset.
@_transparent
public func + <Pointee: ~Copyable>(
    lhs: Tagged<Pointee, Ordinal>.Offset,
    rhs: UnsafePointer<Pointee>
) -> UnsafePointer<Pointee> {
    unsafe rhs.advanced(by: Int(bitPattern: lhs))
}

/// Retreats a pointer by a typed element offset.
@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafePointer<Pointee> {
    unsafe lhs.advanced(by: -Int(bitPattern: rhs))
}

/// Computes the typed element distance between two pointers.
@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: UnsafePointer<Pointee>
) -> Tagged<Pointee, Ordinal>.Offset {
    Tagged<Pointee, Ordinal>.Offset(Affine.Discrete.Vector(unsafe rhs.distance(to: lhs)))
}

// MARK: - UnsafePointer Subscript

extension UnsafePointer where Pointee: ~Copyable {
    /// Accesses the element at the given typed index.
    ///
    /// This subscript enables type-safe pointer access using `Tagged<Pointee, Ordinal>`:
    ///
    /// ```swift
    /// (.zero..<count).forEach { idx in
    ///     print(elements[idx])  // idx is Tagged<Element, Ordinal>
    /// }
    /// ```
    ///
    /// - Parameter index: A typed index into the pointer's memory.
    /// - Returns: The element at the specified index.
    /// - Note: Converts index to offset from zero: `self + (index - .zero)`.
    @inlinable @inline(always)
    public subscript(index: Tagged<Pointee, Ordinal>) -> Pointee {
        @_transparent
        unsafeAddress {
            // Affine: point + (point - origin) = point + vector
            unsafe self + Tagged<Pointee, Ordinal>.Offset(__unchecked: (), index)
        }
    }
}
