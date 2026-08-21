public import Affine_Discrete_Primitives
public import Hash_Primitives

extension Affine.Discrete.Vector: Hash.`Protocol` {

    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
