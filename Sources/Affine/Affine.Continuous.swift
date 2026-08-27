public import Dimension
public import Linear

extension Affine {

    public enum Continuous<Scalar: ~Copyable, Space>: ~Copyable {}
}

extension Affine.Continuous: Copyable where Scalar: Copyable {}
extension Affine.Continuous: Sendable where Scalar: Sendable {}

extension Affine.Continuous {

    public typealias X = Coordinate.X<Space>.Value<Scalar>

    public typealias Y = Coordinate.Y<Space>.Value<Scalar>

    public typealias Z = Coordinate.Z<Space>.Value<Scalar>

    public typealias W = Coordinate.W<Space>.Value<Scalar>
}

extension Affine.Continuous {

    public typealias Dx = Linear<Scalar, Space>.Dx

    public typealias Dy = Linear<Scalar, Space>.Dy

    public typealias Dz = Linear<Scalar, Space>.Dz
}

extension Affine.Continuous {

    public typealias Distance = Dimension.Distance<Space, Scalar>

    public typealias Area = Dimension.Area<Space>.Value<Scalar>
}
