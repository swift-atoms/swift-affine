// Affine.Discrete.Vector+Comparison.Protocol.swift
// Conformance of Affine.Discrete.Vector to Comparison.Protocol — unconditional.
//
// On Swift <6.4, `Comparison.Protocol` is the institute fork supporting
// `borrowing` parameters for `~Copyable` conformers. On Swift 6.4+, it is
// a typealias to `Swift.Comparable` per SE-0499 — this same extension then
// satisfies the stdlib `Comparable` conformance directly. The stdlib
// `extension Affine.Discrete.Vector: Comparable {}` in
// `Affine.Discrete.Vector.swift` is guarded `#if swift(<6.4)` to avoid
// duplicate-conformance.

public import Affine_Discrete_Primitives
public import Comparison_Primitives

#if swift(<6.4)
    extension Affine.Discrete.Vector: Comparable {}
#endif

extension Affine.Discrete.Vector: Comparison.`Protocol` {}
