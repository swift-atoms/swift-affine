#if Vector
@_exported public import Vector

extension Affine {

    public static func componentwise<let N: Int, PositionScalar, DisplacementScalar>(
        coordinates: @escaping (Point) -> Vector<N, PositionScalar>,
        point: @escaping (Vector<N, PositionScalar>) -> Point,
        components: @escaping (Displacement) -> Vector<N, DisplacementScalar>,
        displacement: @escaping (Vector<N, DisplacementScalar>) -> Displacement,
        translating: @escaping (PositionScalar, DisplacementScalar) throws(Failure) -> PositionScalar,
        subtracting: @escaping (PositionScalar, PositionScalar) throws(Failure) -> DisplacementScalar
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
