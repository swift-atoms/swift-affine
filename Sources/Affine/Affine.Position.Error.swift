extension Affine.Position where Domain: ~Copyable & ~Escapable {
    public enum Error: Swift.Error, Hashable, Sendable {
        case overflow
    }
}
