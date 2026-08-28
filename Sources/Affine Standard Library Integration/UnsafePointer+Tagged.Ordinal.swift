public import Affine_Discrete
public import Affine_Tagged
public import Ordinal
public import Ordinal_Protocol
public import Tagged

@_transparent
public func + <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafePointer<Pointee> {
    unsafe lhs.advanced(by: Int(bitPattern: rhs))
}

@_transparent
public func + <Pointee: ~Copyable>(
    lhs: Tagged<Pointee, Ordinal>.Offset,
    rhs: UnsafePointer<Pointee>
) -> UnsafePointer<Pointee> {
    unsafe rhs.advanced(by: Int(bitPattern: lhs))
}

@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: Tagged<Pointee, Ordinal>.Offset
) -> UnsafePointer<Pointee> {
    unsafe lhs.advanced(by: -Int(bitPattern: rhs))
}

@_transparent
public func - <Pointee: ~Copyable>(
    lhs: UnsafePointer<Pointee>,
    rhs: UnsafePointer<Pointee>
) -> Tagged<Pointee, Ordinal>.Offset {
    Tagged<Pointee, Ordinal>.Offset(Affine.Discrete.Vector(unsafe rhs.distance(to: lhs)))
}

extension UnsafePointer where Pointee: ~Copyable {

    @inlinable @inline(always)
    public subscript(index: Tagged<Pointee, Ordinal>) -> Pointee {
        @_transparent
        unsafeAddress {

            unsafe self + Tagged<Pointee, Ordinal>.Offset(_unchecked: (), index)
        }
    }
}
