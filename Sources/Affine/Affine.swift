public struct Affine<Point, Displacement, Failure: Swift.Error> {
    private let translate: (Point, Displacement) throws(Failure) -> Point
    private let difference: (Point, Point) throws(Failure) -> Displacement

    public init(
        translating: @escaping (Point, Displacement) throws(Failure) -> Point,
        displacement: @escaping (Point, Point) throws(Failure) -> Displacement
    ) {
        self.translate = translating
        self.difference = displacement
    }

    public func translated(_ point: Point, by displacement: Displacement) throws(Failure) -> Point {
        try translate(point, displacement)
    }

    public func displacement(from start: Point, to end: Point) throws(Failure) -> Displacement {
        try difference(start, end)
    }
}
