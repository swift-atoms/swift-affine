public import Carrier_Primitives

extension UnsafeMutableRawPointer {

    @inlinable
    public func advanced(by offset: some Carrier.`Protocol`<Affine.Discrete.Vector>) -> Self {
        unsafe self.advanced(by: Int(bitPattern: offset.underlying))
    }

    @inlinable
    public func load<T>(
        fromByteOffset offset: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        as type: T.Type
    ) -> T {
        unsafe self.load(
            fromByteOffset: Int(bitPattern: offset.underlying),
            as: type
        )
    }

    @inlinable
    public func storeBytes<T>(
        of value: T,
        toByteOffset offset: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        as type: T.Type
    ) {
        unsafe self.storeBytes(
            of: value,
            toByteOffset: Int(bitPattern: offset.underlying),
            as: type
        )
    }
}
