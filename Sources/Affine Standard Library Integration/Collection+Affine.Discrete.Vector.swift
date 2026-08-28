public import Carrier

extension Collection {

    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>
    ) -> Self.Index {
        self.index(i, offsetBy: Int(bitPattern: distance.underlying))
    }

    @inlinable
    public func index(
        _ i: Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        limitedBy limit: Self.Index
    ) -> Self.Index? {
        self.index(i, offsetBy: Int(bitPattern: distance.underlying), limitedBy: limit)
    }

    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>
    ) {
        self.formIndex(&i, offsetBy: Int(bitPattern: distance.underlying))
    }

    @discardableResult
    @inlinable
    public func formIndex(
        _ i: inout Self.Index,
        offsetBy distance: some Carrier.`Protocol`<Affine.Discrete.Vector>,
        limitedBy limit: Self.Index
    ) -> Bool {
        self.formIndex(&i, offsetBy: Int(bitPattern: distance.underlying), limitedBy: limit)
    }
}
