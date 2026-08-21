public import Affine_Arithmetic_Primitives
public import Affine_Carrier_Primitives
public import Affine_Discrete_Primitives
public import Cardinal_Primitives
public import Ordinal_Primitives
public import Tagged_Primitives

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    public typealias Offset = Tagged<Tag, Affine.Discrete.Vector>
}

extension Tagged where Underlying == Affine.Discrete.Vector, Tag: ~Copyable & ~Escapable {

    @inlinable
    public var magnitude: Tagged<Tag, Cardinal> {
        .init(_unchecked: vector.magnitude)
    }
}

extension Tagged where Underlying == Affine.Discrete.Vector, Tag: ~Copyable & ~Escapable {

    @inlinable
    public init(
        _ underlying: Int
    ) {
        self.init(_unchecked: Affine.Discrete.Vector(underlying))
    }

    @inlinable
    public init<T: ~Copyable & ~Escapable>(
        _ count: Tagged<T, Cardinal>
    ) {
        self.init(_unchecked: Affine.Discrete.Vector(Int(bitPattern: count)))
    }

    @inlinable
    public init(
        _ index: some Ordinal.`Protocol`
    ) throws(Affine.Discrete.Vector.Error) {
        self.init(_unchecked: try index.ordinal - Ordinal.zero)
    }

    @inlinable
    public init(
        _unchecked: Void,
        _ ordinal: some Ordinal.`Protocol`
    ) {
        assert(
            ordinal.ordinal.rawValue <= UInt(Int.max),
            "Ordinal exceeds Int.max; cannot represent as signed Vector"
        )
        self.init(_unchecked: Affine.Discrete.Vector(Int(bitPattern: ordinal)))
    }

    @inlinable
    public init(fromZero position: some Ordinal.`Protocol`) {
        self.init(Affine.Discrete.Vector(Int(bitPattern: position)))
    }
}

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public static func - (
        lhs: Self,
        rhs: Tagged<Tag, Affine.Discrete.Vector>
    ) throws(Ordinal.Error) -> Self {
        try Self(lhs.ordinal - rhs.vector)
    }

    @inlinable
    public static func -= (
        lhs: inout Self,
        rhs: Tagged<Tag, Affine.Discrete.Vector>
    ) throws(Ordinal.Error) {
        lhs = try lhs - rhs
    }
}

extension Tagged where Underlying == Cardinal, Tag: ~Copyable & ~Escapable {

    @inlinable
    public init(
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) throws(Cardinal.Error) {
        guard offset.vector.rawValue >= 0 else {
            throw .negativeSource(offset.vector.rawValue)
        }
        self.init(_unchecked: Cardinal(UInt(offset.vector.rawValue)))
    }

    @inlinable
    public init(
        _unchecked: Void,
        _ offset: Tagged<Tag, Affine.Discrete.Vector>
    ) {
        assert(
            offset.vector.rawValue >= 0,
            "Vector must be non-negative for unchecked Cardinal conversion"
        )
        self.init(_unchecked: Cardinal(UInt(offset.vector.rawValue)))
    }
}

@inlinable
public func - <Tag: ~Copyable & ~Escapable>(
    lhs: some Ordinal.`Protocol`,
    rhs: some Ordinal.`Protocol`
) throws(Affine.Discrete.Vector.Error) -> Tagged<Tag, Affine.Discrete.Vector> {
    Tagged<Tag, Affine.Discrete.Vector>(_unchecked: try lhs.ordinal - rhs.ordinal)
}

@inlinable
public func * <From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>(
    lhs: Tagged<From, Cardinal>,
    rhs: Affine.Discrete.Ratio<From, To>
) -> Tagged<To, Cardinal> {

    let signedLHS = Int(bitPattern: lhs)
    let result = signedLHS * rhs.factor
    precondition(result >= 0, "Scaled cardinal must be non-negative")
    return Tagged<To, Cardinal>(_unchecked: Cardinal(UInt(result)))
}

@inlinable
public func * <From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>(
    lhs: Affine.Discrete.Ratio<From, To>,
    rhs: Tagged<From, Cardinal>
) -> Tagged<To, Cardinal> {
    rhs * lhs
}

@inlinable
public func * <From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>(
    lhs: Tagged<From, Affine.Discrete.Vector>,
    rhs: Affine.Discrete.Ratio<From, To>
) -> Tagged<To, Affine.Discrete.Vector> {
    Tagged<To, Affine.Discrete.Vector>(
        _unchecked: Affine.Discrete.Vector(lhs.vector.rawValue * rhs.factor)
    )
}

@inlinable
public func * <From: ~Copyable & ~Escapable, To: ~Copyable & ~Escapable>(
    lhs: Affine.Discrete.Ratio<From, To>,
    rhs: Tagged<From, Affine.Discrete.Vector>
) -> Tagged<To, Affine.Discrete.Vector> {
    rhs * lhs
}
