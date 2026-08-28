public import Affine_Discrete
public import Ordinal
public import Ordinal_Error

extension Ordinal {

    @inlinable
    public init(_ vector: Affine.Discrete.Vector) throws(Self.Error) {
        guard vector.rawValue >= 0 else {
            throw .negativeSource(vector.rawValue)
        }
        self.init(UInt(vector.rawValue))
    }
}
