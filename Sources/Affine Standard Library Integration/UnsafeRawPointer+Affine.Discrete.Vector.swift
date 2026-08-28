public import Affine_Discrete
public import Carrier_Protocol

extension UnsafeRawPointer {

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
}
