extension RandomAccessCollection {

    @inlinable
    public func index<T: ~Copyable & ~Escapable>(
        _ i: Index,
        offsetBy offset: Tagged<T, Ordinal>.Offset
    ) -> Index {
        index(i, offsetBy: offset.vector.rawValue)
    }
}
