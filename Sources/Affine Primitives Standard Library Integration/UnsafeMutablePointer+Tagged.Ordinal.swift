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

// MARK: - UnsafeMutablePointer + Tagged<Pointee, Ordinal>.Offset Arithmetic
//
// Affine arithmetic: pointer (point) + offset (vector) = pointer (point)
// This is mathematically correct - we add a displacement to a position.

/// Advances a mutable pointer by a typed element offset.
@_transparent
public func + <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafeMutablePointer<Pointee> {
    unsafe lhs.advanced(by: Int(rhs.rawValue.rawValue))
}

/// Advances a mutable pointer by a typed element offset.
@_transparent
public func + <Pointee: ~Copyable>(
    lhs: Tagged<Pointee, Ordinal>.Offset,
    rhs: UnsafeMutablePointer<Pointee>
) -> UnsafeMutablePointer<Pointee> {
    unsafe rhs.advanced(by: Int(lhs.rawValue.rawValue))
}

/// Retreats a mutable pointer by a typed element offset.
@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafeMutablePointer<Pointee> {
    unsafe lhs.advanced(by: -Int(rhs.rawValue.rawValue))
}

/// Computes the typed element distance between two mutable pointers.
@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: UnsafeMutablePointer<Pointee>
) -> Tagged<Pointee, Ordinal>.Offset {
    Tagged<Pointee, Ordinal>.Offset(Affine.Discrete.Vector(unsafe rhs.distance(to: lhs)))
}

// MARK: - UnsafeMutablePointer Subscript

extension UnsafeMutablePointer where Pointee: ~Copyable {
    /// Accesses the element at the given typed index.
    ///
    /// This subscript enables type-safe pointer access using `Tagged<Pointee, Ordinal>`:
    ///
    /// ```swift
    /// (.zero..<count).forEach { idx in
    ///     body(elements[idx])  // idx is Tagged<Element, Ordinal>
    /// }
    /// ```
    ///
    /// - Parameter index: A typed index into the pointer's memory.
    /// - Returns: The element at the specified index.
    /// - Note: Converts index to offset from zero: `self + (index - .zero)`.
    @inlinable @inline(__always)
    public subscript(index: Tagged<Pointee, Ordinal>) -> Pointee {
        @_transparent
        unsafeAddress {
            // Affine: point + (point - origin) = point + vector
            unsafe UnsafePointer(self + Tagged<Pointee, Ordinal>.Offset(__unchecked: (), index))
        }
        @_transparent
        nonmutating unsafeMutableAddress {
            // Affine: point + (point - origin) = point + vector
            unsafe self + Tagged<Pointee, Ordinal>.Offset(__unchecked: (), index)
        }
    }
}

// MARK: - UnsafeMutablePointer Swap

extension UnsafeMutablePointer where Pointee: ~Copyable {
    /// Swaps elements at two typed indices.
    ///
    /// Performs a move-based swap of the elements at positions `i` and `j`.
    /// Both positions must point to initialized memory.
    ///
    /// ```swift
    /// ptr.swap(parentIndex, childIndex)
    /// ```
    ///
    /// - Parameters:
    ///   - i: The first typed index.
    ///   - j: The second typed index.
    /// - Precondition: Both indices must point to initialized memory.
    @inlinable
    public func swap(
        _ i: Tagged<Pointee, Ordinal>,
        _ j: Tagged<Pointee, Ordinal>
    ) {
        let ptrI = unsafe self + Tagged<Pointee, Ordinal>.Offset(__unchecked: (), i)
        let ptrJ = unsafe self + Tagged<Pointee, Ordinal>.Offset(__unchecked: (), j)
        let temp = unsafe ptrI.move()
        unsafe ptrI.initialize(to: ptrJ.move())
        unsafe ptrJ.initialize(to: temp)
    }
}

// MARK: - UnsafeMutablePointer Allocation

extension UnsafeMutablePointer {
    /// Allocates uninitialized memory for the specified number of instances.
    ///
    /// - Parameter capacity: The typed count of instances to allocate.
    /// - Returns: A pointer to the allocated memory.
    @inlinable
    public static func allocate(
        capacity: Tagged<Pointee, Ordinal>.Count
    ) -> UnsafeMutablePointer {
        Self.allocate(capacity: Int(bitPattern: capacity.count))
    }
}

// MARK: - UnsafeMutablePointer Lifecycle Operations (Copyable)

extension UnsafeMutablePointer {
    /// Initializes the pointer's memory with the specified number of consecutive
    /// copies of the given value.
    ///
    /// - Parameters:
    ///   - repeatedValue: The instance to initialize this pointer's memory with.
    ///   - count: The number of consecutive copies to initialize.
    @inlinable
    public func initialize(
        repeating repeatedValue: Pointee,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.initialize(repeating: repeatedValue, count: Int(bitPattern: count.count))
    }
    
    /// Initializes this pointer's memory by copying the specified number of
    /// consecutive values from the given pointer.
    ///
    /// - Parameters:
    ///   - source: A pointer to the values to copy.
    ///   - count: The number of consecutive values to initialize.
    @inlinable
    public func initialize(
        from source: UnsafePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.initialize(from: source, count: Int(bitPattern: count.count))
    }

    /// Updates this pointer's initialized memory with the specified number
    /// of consecutive copies of the given value.
    ///
    /// - Parameters:
    ///   - repeatedValue: The value with which to update this pointer's memory.
    ///   - count: The number of consecutive elements to update.
    @inlinable
    public func update(
        repeating repeatedValue: Pointee,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.update(repeating: repeatedValue, count: Int(bitPattern: count.count))
    }
}

// MARK: - UnsafeMutablePointer Lifecycle Operations (~Copyable)

extension UnsafeMutablePointer where Pointee: ~Copyable {
    /// Deinitializes the specified number of values starting at this pointer.
    ///
    /// - Parameter count: The number of consecutive instances to deinitialize.
    /// - Returns: A raw pointer to the same address as this pointer.
    @inlinable
    @discardableResult
    public func deinitialize(
        count: Tagged<Pointee, Ordinal>.Count
    ) -> UnsafeMutableRawPointer {
        unsafe self.deinitialize(count: Int(bitPattern: count.count))
    }
}
