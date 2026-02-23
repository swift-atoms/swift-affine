// Affine.Discrete.Vector.Protocol+One.swift

/// Unit vector (displacement of 1) for vector protocol conformers.
///
/// Unit displacement is fundamental to discrete affine spaces — it is
/// the canonical step size for `index(after:)`, iteration, and basic
/// offset arithmetic. Both `Affine.Discrete.Vector` and
/// `Tagged<Tag, Vector>` (i.e., `Offset`) receive `.one` through
/// protocol conformance.
///
/// No ambiguity with `Cardinal.Protocol.one` exists because the
/// conformance constraints are mutually exclusive:
/// - `Cardinal.Protocol` requires `RawValue == Cardinal`
/// - `Affine.Discrete.Vector.Protocol` requires `RawValue == Affine.Discrete.Vector`
///
/// See: `swift-affine-primitives/Research/vector-unit-displacement-layering.md`
extension Affine.Discrete.Vector.`Protocol` {
    /// The unit vector (displacement of 1).
    @inlinable
    public static var one: Self { Self(Affine.Discrete.Vector(1)) }
}
