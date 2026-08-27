public import Cardinal
public import Ordinal
public import Tagged

extension Affine.Discrete.Ratio where From: ~Copyable, To: ~Copyable {

    @inlinable
    public func quotientAndRemainder(
        dividing count: Tagged<To, Cardinal>
    ) throws(Error) -> (quotient: Tagged<From, Cardinal>, remainder: Tagged<To, Cardinal>) {
        guard factor != 0 else { throw .zeroFactor }
        guard factor > 0 else { throw .negativeFactor(factor) }
        guard count.underlying.rawValue <= UInt(Int.max) else { throw .unrepresentable }
        let (q, r) = Int(count.underlying.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Cardinal>(_unchecked: Cardinal(UInt(q))),
            remainder: Tagged<To, Cardinal>(_unchecked: Cardinal(UInt(r)))
        )
    }

    @inlinable
    public func quotientAndRemainder(
        dividing index: Tagged<To, Ordinal>
    ) throws(Error) -> (
        quotient: Tagged<From, Ordinal>, remainder: Tagged<To, Affine.Discrete.Vector>
    ) {
        guard factor != 0 else { throw .zeroFactor }
        guard factor > 0 else { throw .negativeFactor(factor) }
        guard index.underlying.rawValue <= UInt(Int.max) else { throw .unrepresentable }
        let (q, r) = Int(index.underlying.rawValue).quotientAndRemainder(dividingBy: factor)
        return (
            quotient: Tagged<From, Ordinal>(_unchecked: Ordinal(UInt(q))),
            remainder: Tagged<To, Affine.Discrete.Vector>(_unchecked: Affine.Discrete.Vector(r))
        )
    }
}
