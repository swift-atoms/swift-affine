public import Affine_Discrete
public import Cardinal
public import Tagged

extension Affine.Discrete.Ratio where From: ~Copyable, To: ~Copyable {

    @inlinable
    public init(_ count: Tagged<To, Cardinal>) {
        self.init(Int(bitPattern: count))
    }
}
