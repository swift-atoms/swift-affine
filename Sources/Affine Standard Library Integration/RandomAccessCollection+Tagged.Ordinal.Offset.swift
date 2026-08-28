public import Affine_Carrier
public import Affine_Discrete
public import Affine_Tagged
public import Ordinal
public import Tagged

extension RandomAccessCollection {

    @inlinable
    public func index<T: ~Copyable & ~Escapable>(
        _ i: Index,
        offsetBy offset: Tagged<T, Ordinal>.Offset
    ) -> Index {
        index(i, offsetBy: offset.vector.rawValue)
    }
}
