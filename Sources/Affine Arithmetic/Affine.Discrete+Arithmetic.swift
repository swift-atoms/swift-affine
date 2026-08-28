public import Affine_Carrier
public import Affine_Discrete
internal import Cardinal
public import Carrier
public import Ordinal

@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) -> O {
    guard rhs.vector.rawValue >= 0 else {
        let magnitude = rhs.vector.rawValue.magnitude
        guard lhs.ordinal.rawValue >= magnitude else { throw .underflow }
        return O(Ordinal(lhs.ordinal.rawValue - magnitude))
    }
    let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(UInt(rhs.vector.rawValue))
    guard !overflow else { throw .overflow }
    return O(Ordinal(result))
}

@inlinable
public func + <O: Ordinal.`Protocol`>(
    lhs: some Carrier.`Protocol`<Affine.Discrete.Vector>,
    rhs: O
) throws(Ordinal.Error) -> O {
    try rhs + lhs
}

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
    let (result, overflow) = lhs.ordinal.rawValue.addingReportingOverflow(
        rhs.vector.rawValue.magnitude
    )
    guard !overflow else { throw .overflow }
    return O(Ordinal(result))
}

@inlinable
public func - (
    lhs: some Ordinal.`Protocol`,
    rhs: some Ordinal.`Protocol`
) throws(Affine.Discrete.Vector.Error) -> Affine.Discrete.Vector {
    guard lhs.ordinal.rawValue >= rhs.ordinal.rawValue else {
        let difference = rhs.ordinal.rawValue - lhs.ordinal.rawValue

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

@inlinable
public func += <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs + rhs
}

@inlinable
public func -= <O: Ordinal.`Protocol`>(
    lhs: inout O,
    rhs: some Carrier.`Protocol`<Affine.Discrete.Vector>
) throws(Ordinal.Error) {
    lhs = try lhs - rhs
}

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
    guard lhs.vector.rawValue >= 0 else { return true }
    return UInt(lhs.vector.rawValue) < rhs.cardinal.rawValue
}

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
    guard lhs.vector.rawValue >= 0 else { return true }
    return UInt(lhs.vector.rawValue) <= rhs.cardinal.rawValue
}

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
    guard lhs.vector.rawValue >= 0 else { return false }
    return UInt(lhs.vector.rawValue) > rhs.cardinal.rawValue
}

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
    guard lhs.vector.rawValue >= 0 else { return false }
    return UInt(lhs.vector.rawValue) >= rhs.cardinal.rawValue
}

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
    guard rhs.vector.rawValue >= 0 else { return false }
    return lhs.cardinal.rawValue < UInt(rhs.vector.rawValue)
}

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
    guard rhs.vector.rawValue >= 0 else { return false }
    return lhs.cardinal.rawValue <= UInt(rhs.vector.rawValue)
}

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
    guard rhs.vector.rawValue >= 0 else { return true }
    return lhs.cardinal.rawValue > UInt(rhs.vector.rawValue)
}

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
    guard rhs.vector.rawValue >= 0 else { return true }
    return lhs.cardinal.rawValue >= UInt(rhs.vector.rawValue)
}
