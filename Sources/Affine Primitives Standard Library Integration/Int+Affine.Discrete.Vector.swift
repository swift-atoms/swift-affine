public import Carrier_Primitives

extension Int {

    @inlinable
    public init(bitPattern vector: Affine.Discrete.Vector) {
        self = vector.rawValue
    }

    @inlinable
    public init<Tag: ~Copyable & ~Escapable>(bitPattern offset: Tagged<Tag, Affine.Discrete.Vector>)
    {
        self.init(bitPattern: offset.underlying)
    }

    @inlinable
    public init(bitPattern carrier: some Carrier.`Protocol`<Affine.Discrete.Vector>) {
        self.init(bitPattern: carrier.underlying)
    }
}
