// Affine.Discrete.Vector+Hash.Protocol.swift
// Conformance of Affine.Discrete.Vector to Hash.Protocol — unconditional.

// The explicit `hash(into:)` is required (rather than relying on synthesis)
// because Hashable synthesis only fires when the conformance is declared in
// the same file as the type. The single-property hash collapses to a single
// `combine` over `rawValue`.

public import Affine_Discrete_Primitives
public import Hash_Primitives

extension Affine.Discrete.Vector: Hash.`Protocol` {
    /// Feeds the underlying value into the given hasher.
    @inlinable
    public borrowing func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
