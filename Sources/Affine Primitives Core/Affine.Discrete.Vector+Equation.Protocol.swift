// Affine.Discrete.Vector+Equation.Protocol.swift
// Conformance of Affine.Discrete.Vector to Equation.Protocol — unconditional.
//
// On Swift <6.4, `Equation.Protocol` is the institute fork supporting
// `borrowing` parameters for `~Copyable` conformers. On Swift 6.4+, it is
// a typealias to `Swift.Equatable` per SE-0499 — this same extension then
// satisfies the stdlib `Equatable` conformance directly. The stdlib
// `extension Affine.Discrete.Vector: Hashable {}` in `Affine.Discrete.Vector.swift`
// is guarded `#if swift(<6.4)` to avoid duplicate-conformance.

extension Affine.Discrete.Vector: Equation.`Protocol` {}
