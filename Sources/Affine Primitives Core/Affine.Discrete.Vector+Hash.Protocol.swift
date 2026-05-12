// Affine.Discrete.Vector+Hash.Protocol.swift
// Conformance of Affine.Discrete.Vector to Hash.Protocol — unconditional.
//
// On Swift <6.4, `Hash.Protocol` is the institute fork supporting `borrowing`
// parameters for `~Copyable` conformers. On Swift 6.4+, it is a typealias
// to `Swift.Hashable` per SE-0499 — this same extension then satisfies the
// stdlib `Hashable` conformance directly. The stdlib
// `extension Affine.Discrete.Vector: Hashable {}` in
// `Affine.Discrete.Vector.swift` is guarded `#if swift(<6.4)` to avoid
// duplicate-conformance.
//
// The explicit `hash(into:)` is required (rather than relying on synthesis)
// because Hashable synthesis only fires when the conformance is declared in
// the same file as the type. The single-property hash collapses to a single
// `combine` over `rawValue`.

extension Affine.Discrete.Vector: Hash.`Protocol` {
    /// Feeds the underlying value into the given hasher.
    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
