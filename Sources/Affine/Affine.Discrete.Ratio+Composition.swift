
@inlinable
public func * <A: ~Copyable, B: ~Copyable, C: ~Copyable>(
    lhs: Affine.Discrete.Ratio<A, B>,
    rhs: Affine.Discrete.Ratio<B, C>
) -> Affine.Discrete.Ratio<A, C> {
    Affine.Discrete.Ratio<A, C>(lhs.factor * rhs.factor)
}
