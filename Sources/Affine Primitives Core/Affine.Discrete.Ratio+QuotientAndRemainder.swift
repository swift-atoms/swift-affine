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

// MARK: - Typed quotientAndRemainder

extension Affine.Discrete.Ratio where From: ~Copyable, To: ~Copyable {
    /// Divides a cardinal count in the `To` domain by this ratio's factor.
    ///
    /// Returns a quotient in the `From` domain and a remainder in the `To` domain,
    /// both preserving their phantom types.
    ///
    /// ## Semantic Model
    ///
    /// Given `Ratio<Word, Bit>(64)` and a bit count of 100:
    /// - quotient = 1 (1 full word)
    /// - remainder = 36 (36 remaining bits)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bitsPerWord = Affine.Discrete.Ratio<UInt, Bit>(64)
    /// let bitCount: Tagged<Bit, Cardinal> = ...
    /// let (wordCount, remainingBits) = bitsPerWord.quotientAndRemainder(dividing: bitCount)
    /// // wordCount: Tagged<UInt, Cardinal>
    /// // remainingBits: Tagged<Bit, Cardinal>
    /// ```
    ///
    /// - Parameter count: A cardinal count in the `To` domain.
    /// - Returns: A tuple of (quotient in `From` domain, remainder in `To` domain).
    @inlinable
    public func quotientAndRemainder(
        dividing count: Tagged<To, Cardinal>
    ) -> (quotient: Tagged<From, Cardinal>, remainder: Tagged<To, Cardinal>) {
        let (q, r) = Int(bitPattern: count.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Cardinal>(__unchecked: (), Cardinal(UInt(q))),
            remainder: Tagged<To, Cardinal>(__unchecked: (), Cardinal(UInt(r)))
        )
    }

    /// Divides an ordinal position in the `To` domain by this ratio's factor.
    ///
    /// Returns a quotient as an ordinal in the `From` domain and a remainder
    /// as a vector (offset within a single `From` unit) in the `To` domain.
    ///
    /// ## Semantic Model
    ///
    /// Given `Ratio<Word, Bit>(64)` and bit index 100:
    /// - quotient = ordinal 1 (word at position 1)
    /// - remainder = vector 36 (bit offset 36 within that word)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let bitsPerWord = Affine.Discrete.Ratio<UInt, Bit>(64)
    /// let bitIndex: Tagged<Bit, Ordinal> = ...
    /// let (wordIndex, bitOffset) = bitsPerWord.quotientAndRemainder(dividing: bitIndex)
    /// // wordIndex: Tagged<UInt, Ordinal>
    /// // bitOffset: Tagged<Bit, Affine.Discrete.Vector>
    /// ```
    ///
    /// - Parameter index: An ordinal position in the `To` domain.
    /// - Returns: A tuple of (ordinal in `From` domain, offset within `From` unit).
    @inlinable
    public func quotientAndRemainder(
        dividing index: Tagged<To, Ordinal>
    ) -> (quotient: Tagged<From, Ordinal>, remainder: Tagged<To, Affine.Discrete.Vector>) {
        let (q, r) = Int(bitPattern: index.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Ordinal>(__unchecked: (), Ordinal(UInt(q))),
            remainder: Tagged<To, Affine.Discrete.Vector>(__unchecked: (), Affine.Discrete.Vector(r))
        )
    }
}
