// The failure representation is independent of the phantom coordinate domain.
public enum __AffinePositionError: Swift.Error, Hashable, Sendable {
    case overflow
}

extension Affine.Position where Domain: ~Copyable & ~Escapable {
    public typealias Error = __AffinePositionError
}
