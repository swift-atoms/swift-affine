@_transparent
public func + <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafeMutablePointer<Pointee> {
    unsafe lhs.advanced(by: Int(bitPattern: rhs))
}

@_transparent
public func + <Pointee: ~Copyable>(
    lhs: Tagged<Pointee, Ordinal>.Offset,
    rhs: UnsafeMutablePointer<Pointee>
) -> UnsafeMutablePointer<Pointee> {
    unsafe rhs.advanced(by: Int(bitPattern: lhs))
}

@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafeMutablePointer<Pointee> {
    unsafe lhs.advanced(by: -Int(bitPattern: rhs))
}

@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafeMutablePointer<Pointee>,
    rhs: UnsafeMutablePointer<Pointee>
) -> Tagged<Pointee, Ordinal>.Offset {
    Tagged<Pointee, Ordinal>.Offset(Affine.Discrete.Vector(unsafe rhs.distance(to: lhs)))
}

extension UnsafeMutablePointer where Pointee: ~Copyable {

    @inlinable @inline(always)
    public subscript(index: Tagged<Pointee, Ordinal>) -> Pointee {
        @_transparent
        unsafeAddress {

            unsafe UnsafePointer(self + Tagged<Pointee, Ordinal>.Offset(_unchecked: (), index))
        }
        @_transparent
        nonmutating unsafeMutableAddress {

            unsafe self + Tagged<Pointee, Ordinal>.Offset(_unchecked: (), index)
        }
    }
}

extension UnsafeMutablePointer where Pointee: ~Copyable {

    @inlinable
    public func swap(
        _ i: Tagged<Pointee, Ordinal>,
        _ j: Tagged<Pointee, Ordinal>
    ) {
        let ptrI = unsafe self + Tagged<Pointee, Ordinal>.Offset(_unchecked: (), i)
        let ptrJ = unsafe self + Tagged<Pointee, Ordinal>.Offset(_unchecked: (), j)
        guard unsafe ptrI != ptrJ else { return }
        let temp = unsafe ptrI.move()
        unsafe ptrI.initialize(to: ptrJ.move())
        unsafe ptrJ.initialize(to: temp)
    }
}

extension UnsafeMutablePointer {

    @inlinable
    public static func allocate(
        capacity: Tagged<Pointee, Ordinal>.Count
    ) -> UnsafeMutablePointer {
        Self.allocate(capacity: Int(bitPattern: capacity.count))
    }
}

extension UnsafeMutablePointer {

    @inlinable
    public func initialize(
        repeating repeatedValue: Pointee,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.initialize(repeating: repeatedValue, count: Int(bitPattern: count.count))
    }

    @inlinable
    public func initialize(
        from source: UnsafePointer<Pointee>,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.initialize(from: source, count: Int(bitPattern: count.count))
    }

    @inlinable
    public func update(
        repeating repeatedValue: Pointee,
        count: Tagged<Pointee, Ordinal>.Count
    ) {
        unsafe self.update(repeating: repeatedValue, count: Int(bitPattern: count.count))
    }
}

extension UnsafeMutablePointer where Pointee: ~Copyable {

    @inlinable
    @discardableResult
    public func deinitialize(
        count: Tagged<Pointee, Ordinal>.Count
    ) -> UnsafeMutableRawPointer {
        unsafe self.deinitialize(count: Int(bitPattern: count.count))
    }
}
