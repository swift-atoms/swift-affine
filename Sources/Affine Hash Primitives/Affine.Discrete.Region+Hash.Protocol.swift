// Affine.Discrete.Region+Hash.Protocol.swift
// Conformance of Affine.Discrete.Region to Hash.Protocol — unconditional.
//
// The `hash(into:)` and `==` witnesses live in the root (Affine.Discrete.Region.swift), so
// this conformance is empty. `Region` is a struct (not auto-Hashable), so the stdlib
// `Hashable` conformance is declared here, guarded `#if swift(<6.4)`.

public import Affine_Discrete_Primitives
public import Hash_Primitives

extension Affine.Discrete.Region: Hash.`Protocol` {}

#if swift(<6.4)
    extension Affine.Discrete.Region: Hashable {}
#endif
