public struct Affine<Point, Displacement, Failure: Swift::Error> {
    private let translate: (Point, Displacement) throws(Failure) -> Point
    private let difference: (Point, Point) throws(Failure) -> Displacement

    public init(
        translating: @escaping (Point, Displacement) throws(Failure) -> Point,
        displacement: @escaping (Point, Point) throws(Failure) -> Displacement
    ) {
        self.translate = translating
        self.difference = displacement
    }
}

extension Affine {

    public func translated(_ point: Point, by displacement: Displacement) throws(Failure) -> Point {
        try translate(point, displacement)
    }

    public func displacement(from start: Point, to end: Point) throws(Failure) -> Displacement {
        try difference(start, end)
    }
}

#if Tagged
    @_exported public import Tagged

    extension Affine {

        public func tagged<Tag: ~Copyable & ~Escapable>(
            _ tag: Tag.Type = Tag.self
        ) -> Affine<Tagged<Tag, Point>, Displacement, Failure> {
            .init(
                translating: { (point, offset) throws(Failure) in
                    Tagged(_unchecked: try self.translated(point.underlying, by: offset))
                },
                displacement: { (start, end) throws(Failure) in
                    try self.displacement(from: start.underlying, to: end.underlying)
                }
            )
        }
    }
#endif

#if Vector
    @_exported public import Vector

    extension Affine {

        public static func componentwise<let N: Int, PositionScalar, DisplacementScalar>(
            coordinates: @escaping (Point) -> Vector<N, PositionScalar>,
            point: @escaping (Vector<N, PositionScalar>) -> Point,
            components: @escaping (Displacement) -> Vector<N, DisplacementScalar>,
            displacement: @escaping (Vector<N, DisplacementScalar>) -> Displacement,
            translating:
                @escaping (PositionScalar, DisplacementScalar) throws(Failure) -> PositionScalar,
            subtracting:
                @escaping (PositionScalar, PositionScalar) throws(Failure) -> DisplacementScalar
        ) -> Self {
            Self(
                translating: { (value, offset) throws(Failure) in
                    let source = coordinates(value)
                    let delta = components(offset)
                    let result: InlineArray<N, PositionScalar> = try InlineArray {
                        (index: Int) throws(Failure) in try translating(source[index], delta[index])
                    }
                    return point(Vector(result))
                },
                displacement: { (start, end) throws(Failure) in
                    let lhs = coordinates(start)
                    let rhs = coordinates(end)
                    let result: InlineArray<N, DisplacementScalar> = try InlineArray {
                        (index: Int) throws(Failure) in try subtracting(lhs[index], rhs[index])
                    }
                    return displacement(Vector(result))
                }
            )
        }
    }
#endif
