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

internal import Cardinal_Primitives
public import Carrier_Primitives
public import Ordinal_Primitives

// MARK: - Position + Vector → Position (Point + Vector → Point)

/// Advances a position by a vector.
///
/// Generic over both `Ordinal.Protocol` and `Carrier.\`Protocol\`<Affine.Discrete.Vector>`,
/// so this single definition handles bare types and their `Tagged` wrappers.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) -> O {
    guard rhs.vector.rawValue >= 0 else {
        // reason: typed-system bottom-out — same `O: Ordinal.Protocol` `+`
        // operator implementation; the underflow branch extracts rhs's
        // unsigned magnitude via stdlib `Int.magnitude` to guard and
        // perform the subtraction in stdlib UInt. [INFRA-103] / [CONV-016]
        // options (i)–(iv) circular. Same wave-2a / wave-2c-rerun pattern.
        // swiftlint:disable:next chained_rawvalue_access_anti_pattern
        let magnitude = rhs.vector.rawValue.magnitude
        guard lhs.ordinal.rawValue >= magnitude else { throw .underflow }
        return O(Ordinal(lhs.ordinal.rawValue - magnitude))
    }
    // reason: typed-system bottom-out — `O: Ordinal.Protocol` (with
    // Carrier-of-Vector rhs) IS the wrapper implementing this `+`
    // operator; lhs.ordinal and rhs.vector are accessed through the
    // underlying typed wrappers, with the call to stdlib UInt
    // overflow-aware addition as the necessary grounding into stdlib
    // arithmetic. [INFRA-103] / [CONV-016] options (i)–(iv) circular
    // here. Direct analog of wave-2a cardinal `+`
    // (swift-cardinal-primitives abd750b) and wave-2c-rerun
    // algebra-modular `*` (swift-algebra-modular-primitives c359228)
    // typed-arithmetic-operator pattern.
    // swiftlint:disable:next chained_rawvalue_access_anti_pattern
    let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(UInt(rhs.vector.rawValue))
    guard !overflow else { throw .overflow }
    return O(Ordinal(result))
}

/// Advances a position by a vector (commutative).
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: some Carrier.`Protocol`<Affine.Discrete.Vector>,
    rhs: O
) throws(Ordinal.Error) -> O {
    try rhs + lhs
}

// MARK: - Position - Vector → Position (Point - Vector → Point)

/// Retreats a position by a vector.
///
/// Generic over both `Ordinal.Protocol` and `Carrier.\`Protocol\`<Affine.Discrete.Vector>`,
/// so this single definition handles bare types and their `Tagged` wrappers.
///
/// - Throws: `Ordinal.Error.overflow` if the result exceeds `UInt.max`.
/// - Throws: `Ordinal.Error.underflow` if the result would be negative.
@inlinable
public func - <O: Ordinal.`Protocol`>(
    lhs: O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) -> O {
    guard rhs.vector.rawValue <= 0 else {
        let magnitude = UInt(rhs.vector.rawValue)
        guard lhs.ordinal.rawValue >= magnitude else { throw .underflow }
        return O(Ordinal(lhs.ordinal.rawValue - magnitude))
    }
    // reason: typed-system bottom-out — `O: Ordinal.Protocol` (with
    // Carrier-of-Vector rhs) IS the wrapper implementing this `-`
    // operator; the negative-rhs branch extracts the unsigned
    // magnitude and adds (since `−(−x) = +x`) via stdlib UInt
    // overflow-aware addition. Both `.rawValue` chains on this line
    // (LHS receiver and RHS argument-magnitude) are the necessary
    // grounding into stdlib arithmetic. [INFRA-103] / [CONV-016]
    // options (i)–(iv) circular. Same wave-2a / wave-2c-rerun
    // typed-arithmetic-operator bottom-out pattern.
    // swiftlint:disable:next chained_rawvalue_access_anti_pattern
    let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(rhs.vector.rawValue.magnitude)
    guard !overflow else { throw .overflow }
    return O(Ordinal(result))
}

// MARK: - Position - Position → Vector (Point - Point → Vector)

/// Returns the signed vector between two positions.
///
/// The result is positive if `lhs > rhs`, negative if `lhs < rhs`.
/// This is the fundamental affine operation: point difference yields a vector.
///
/// - Throws: `Affine.Discrete.Vector.Error.unrepresentable` if the difference exceeds
///   the representable range of `Int` (positions more than ~9.2 quintillion apart).
@inlinable
public func - (
    lhs: some Ordinal.`Protocol`,
    rhs: some Ordinal.`Protocol`
) throws(Affine.Discrete.Vector.Error) -> Affine.Discrete.Vector {
    guard lhs.ordinal.rawValue >= rhs.ordinal.rawValue else {
        let difference = rhs.ordinal.rawValue - lhs.ordinal.rawValue
        // Int.min.magnitude == UInt(Int.max) + 1
        guard difference <= UInt(Int.max) + 1 else { throw .unrepresentable }
        if difference == UInt(Int.max) + 1 {
            return Affine.Discrete.Vector(Int.min)
        }
        return Affine.Discrete.Vector(-Int(difference))
    }
    let difference = lhs.ordinal.rawValue - rhs.ordinal.rawValue
    guard difference <= UInt(Int.max) else { throw .unrepresentable }
    return Affine.Discrete.Vector(Int(difference))
}

// MARK: - Compound Assignment for Ordinal ± Vector

/// Advances an ordinal by a vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func += <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs + rhs
}

/// Retreats an ordinal by a vector in place.
///
/// - Throws: `Ordinal.Error` if the result would overflow or underflow.
@inlinable
public func -= <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs - rhs
}

// MARK: - Vector ↔ Count Comparisons

/// Cross-type comparisons between vectors and cardinals.
///
/// Generic over both `Carrier.\`Protocol\`<Affine.Discrete.Vector>` and
/// `Carrier.\`Protocol\`<Cardinal>` with `V.Domain == C.Domain`, so a single
/// definition handles:
/// - Bare: `Affine.Discrete.Vector` ↔ `Cardinal` (Domain = Never)
/// - Tagged: `Tagged<Tag, Vector>` ↔ `Tagged<Tag, Cardinal>` (Domain = Tag)
///
/// These operators are disfavored so that same-type comparisons
/// (Cardinal < Cardinal, Vector < Vector) are preferred during type inference.
/// This prevents ambiguity when using integer literals.

/// Returns `true` if a same-domain vector is less than a cardinal.
@inlinable
@_disfavoredOverload
public func < <V, C>(
    lhs: V,
    rhs: C
) -> Bool
where
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V.Domain == C.Domain
{
    lhs.vector.rawValue < Int(rhs.cardinal.rawValue)
}

/// Returns `true` if a same-domain vector is less than or equal to a cardinal.
@inlinable
@_disfavoredOverload
public func <= <V, C>(
    lhs: V,
    rhs: C
) -> Bool
where
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V.Domain == C.Domain
{
    lhs.vector.rawValue <= Int(rhs.cardinal.rawValue)
}

/// Returns `true` if a same-domain vector is greater than a cardinal.
@inlinable
@_disfavoredOverload
public func > <V, C>(
    lhs: V,
    rhs: C
) -> Bool
where
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V.Domain == C.Domain
{
    lhs.vector.rawValue > Int(rhs.cardinal.rawValue)
}

/// Returns `true` if a same-domain vector is greater than or equal to a cardinal.
@inlinable
@_disfavoredOverload
public func >= <V, C>(
    lhs: V,
    rhs: C
) -> Bool
where
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V.Domain == C.Domain
{
    lhs.vector.rawValue >= Int(rhs.cardinal.rawValue)
}

// Reverse direction (Cardinal ↔ Vector)

/// Returns `true` if a same-domain cardinal is less than a vector.
@inlinable
@_disfavoredOverload
public func < <C, V>(
    lhs: C,
    rhs: V
) -> Bool
where
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C.Domain == V.Domain
{
    Int(lhs.cardinal.rawValue) < rhs.vector.rawValue
}

/// Returns `true` if a same-domain cardinal is less than or equal to a vector.
@inlinable
@_disfavoredOverload
public func <= <C, V>(
    lhs: C,
    rhs: V
) -> Bool
where
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C.Domain == V.Domain
{
    Int(lhs.cardinal.rawValue) <= rhs.vector.rawValue
}

/// Returns `true` if a same-domain cardinal is greater than a vector.
@inlinable
@_disfavoredOverload
public func > <C, V>(
    lhs: C,
    rhs: V
) -> Bool
where
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C.Domain == V.Domain
{
    Int(lhs.cardinal.rawValue) > rhs.vector.rawValue
}

/// Returns `true` if a same-domain cardinal is greater than or equal to a vector.
@inlinable
@_disfavoredOverload
public func >= <C, V>(
    lhs: C,
    rhs: V
) -> Bool
where
    C: Carrier.`Protocol`,
    C.Underlying == Cardinal,
    V: Carrier.`Protocol`,
    V.Underlying == Affine.Discrete.Vector,
    C.Domain == V.Domain
{
    Int(lhs.cardinal.rawValue) >= rhs.vector.rawValue
}
