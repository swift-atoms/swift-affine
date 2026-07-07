// Affine.Discrete.Region+Equation.Protocol.swift
// Conformance of Affine.Discrete.Region to Equation.Protocol — unconditional.
//
// The `==` witness lives in the root (Affine.Discrete.Region.swift). On Swift 6.4+,
// Equation.Protocol is a typealias to Swift.Equatable per SE-0499; the `#if swift(<6.4)`
// stdlib `Hashable` shim in the Hash sub-target (which implies Equatable) avoids duplicate
// conformance.

public import Affine_Discrete_Primitives
public import Equation_Primitives

extension Affine.Discrete.Region: Equation.`Protocol` {}
