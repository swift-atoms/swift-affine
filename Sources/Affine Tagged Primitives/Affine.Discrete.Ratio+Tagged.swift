public import Affine_Discrete_Primitives
public import Cardinal_Primitives
public import Tagged_Primitives

extension Affine.Discrete.Ratio where From: ~Copyable, To: ~Copyable {

    @inlinable
    public init(_ count: Tagged<To, Cardinal>) {
        self.init(Int(bitPattern: count))
    }
}
