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

public import Affine_Discrete_Primitives
public import Cardinal_Primitives
public import Ordinal_Primitives
public import Tagged_Primitives

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
    /// - Throws: `Error.zeroFactor` if `factor == 0`; `Error.negativeFactor` if
    ///   `factor < 0` (a negative factor would produce a quotient that cannot be
    ///   represented by the unsigned `Cardinal` result); `Error.unrepresentable`
    ///   if `count`'s raw value exceeds `Int.max`.
    @inlinable
    public func quotientAndRemainder(
        dividing count: Tagged<To, Cardinal>
    ) throws(Error) -> (quotient: Tagged<From, Cardinal>, remainder: Tagged<To, Cardinal>) {
        guard factor != 0 else { throw .zeroFactor }
        guard factor > 0 else { throw .negativeFactor(factor) }
        guard count.underlying.rawValue <= UInt(Int.max) else { throw .unrepresentable }
        // swiftlint:disable:next chained_rawvalue_access_paren_evasion - [INFRA-103] this file is the typed quotientAndRemainder wrapper itself (see MARK above), the raw-value bottom-out this site implements, not something for a caller to work around
        let (q, r) = Int(count.underlying.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Cardinal>(_unchecked: Cardinal(UInt(q))),
            remainder: Tagged<To, Cardinal>(_unchecked: Cardinal(UInt(r)))
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
    /// - Throws: `Error.zeroFactor` if `factor == 0`; `Error.negativeFactor` if
    ///   `factor < 0` (a negative factor would produce a quotient that cannot be
    ///   represented by the unsigned `Ordinal` result); `Error.unrepresentable`
    ///   if `index`'s raw value exceeds `Int.max`.
    @inlinable
    public func quotientAndRemainder(
        dividing index: Tagged<To, Ordinal>
    ) throws(Error) -> (quotient: Tagged<From, Ordinal>, remainder: Tagged<To, Affine.Discrete.Vector>) {
        guard factor != 0 else { throw .zeroFactor }
        guard factor > 0 else { throw .negativeFactor(factor) }
        guard index.underlying.rawValue <= UInt(Int.max) else { throw .unrepresentable }
        // swiftlint:disable:next chained_rawvalue_access_paren_evasion - [INFRA-103] this file is the typed quotientAndRemainder wrapper itself (see MARK above), the raw-value bottom-out this site implements, not something for a caller to work around
        let (q, r) = Int(index.underlying.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Ordinal>(_unchecked: Ordinal(UInt(q))),
            remainder: Tagged<To, Affine.Discrete.Vector>(_unchecked: Affine.Discrete.Vector(r))
        )
    }
}
