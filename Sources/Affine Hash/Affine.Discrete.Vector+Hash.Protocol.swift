public import Affine_Discrete
public import Hash

extension Affine.Discrete.Vector: Hash.`Protocol` {

    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
