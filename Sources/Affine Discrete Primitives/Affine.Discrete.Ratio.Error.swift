extension Affine.Discrete.Ratio where From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable {

    public enum Error: Swift.Error, Hashable, Sendable {

        case zeroFactor

        case negativeFactor(Int)

        case unrepresentable
    }
}
