# ``Affine_Primitives_Core/Affine/Discrete/Vector``

@Metadata {
    @DisplayName("Affine.Discrete.Vector")
    @TitleHeading("Affine Primitives")
}

A signed integer-backed displacement in one-dimensional discrete affine space.

## Overview

`Affine.Discrete.Vector` answers the question *"how far between?"*. It is backed by `Int` so signed displacement is representational rather than runtime-checked — there is no construction path that produces a non-integer Vector, and the type system makes negative values first-class.

```swift
let forward: Affine.Discrete.Vector = 5
let backward: Affine.Discrete.Vector = -3
let identity: Affine.Discrete.Vector = .zero
```

A Vector forms an additive group: `+`, `-`, `+=`, `-=`, unary `-`, and `.zero` are all defined; `.one` is the unit displacement. Positions (carried by `Ordinal`) are *not* a group — there is no negative position; `Ordinal.zero - Affine.Discrete.Vector(1)` throws `Ordinal.Error.underflow`. The asymmetry is the affine-space distinction: positions have no canonical origin for arithmetic; vectors have `.zero`.

## Affine Arithmetic

Three operations connect ordinals (positions) and vectors (displacements):

```swift
// position + vector → position
let p: Ordinal = 5
let v: Affine.Discrete.Vector = 3
let q = try p + v                       // Ordinal(8)

// position − vector → position
let r = try p - v                       // Ordinal(2)

// position − position → vector
let displacement = try q - p            // Vector(3)
```

Each operation is typed-throws. `Ordinal.Error` is thrown when the result would over- or under-flow `UInt`; `Affine.Discrete.Vector.Error.unrepresentable` is thrown when a `Position − Position` difference exceeds `Int`'s representable range (positions more than ~9.2 quintillion apart).

The operators are generic over `Ordinal.\`Protocol\`` and `Carrier.\`Protocol\`<Affine.Discrete.Vector>`, so a single declaration handles bare types and any phantom-tagged wrapper:

```swift
let position: Tagged<Element, Ordinal> = 5
let step: Tagged<Element, Ordinal>.Offset = 1
let next = try position + step          // Tagged<Element, Ordinal>(6)
```

See <doc:Tagged-Offsets> for the typed-offset surface.

## Construction

```swift
public init(_ rawValue: Int)            // Total
```

`Affine.Discrete.Vector: ExpressibleByIntegerLiteral` accepts signed literals. Negative literals are valid (Vector is signed); the `@_disfavoredOverload` attribute on the literal init is intentional — same-type comparisons (`Vector < Vector`, `Cardinal < Cardinal`) are preferred during type inference, preventing ambiguity with the cross-type `Vector ↔ Cardinal` comparisons that fire only when both operands are explicitly typed.

## Magnitude

```swift
public var magnitude: Cardinal { Cardinal(rawValue.magnitude) }
```

The magnitude of a Vector is its unsigned distance — a `Cardinal`. The mapping ℤ → ℕ strips direction information; both `forward.magnitude` and `backward.magnitude` (where `forward = Vector(5)`, `backward = Vector(-5)`) yield `Cardinal(5)`.

## Conformances

| Protocol | Source | Notes |
|----------|--------|-------|
| `Hashable`, `Comparable`, `Sendable` | Auto-synthesized via `let rawValue: Int`. |  |
| `Equation.\`Protocol\`` | Cross-package via `swift-equation-primitives`. | Vector explicit `==` matches the synthesized version. |
| `Comparison.\`Protocol\`` | Cross-package via `swift-comparison-primitives`. | Vector explicit `<`, `<=`, `>`, `>=` match the synthesized versions; explicit overloads exist to satisfy the protocol's exact-shape requirement. |
| `Carrier.\`Protocol\`` | Cross-package via `swift-carrier-primitives`. | Trivial self-carrier (`Underlying = Affine.Discrete.Vector`). The `Domain` associated type defaults to `Never`. |
| `CustomStringConvertible` |  | Renders as `Vector(<rawValue>)`. |
| `ExpressibleByIntegerLiteral` |  | Signed literals, `@_disfavoredOverload`. |

## Constants

```swift
public static var zero: Self { ... }   // Vector(0)
public static var one: Self { ... }    // Vector(1)
```

The constants live on `Carrier.\`Protocol\` where Underlying == Affine.Discrete.Vector`, so any `Tagged<Tag, Affine.Discrete.Vector>` (including `Tagged<Tag, Ordinal>.Offset`) inherits `.zero` and `.one` automatically.

## Topics

### Construction

- ``init(_:)``
- ``init(integerLiteral:)``

### Constants

- ``zero``
- ``one``

### Arithmetic

- ``+(_:_:)``
- ``-(_:_:)``
- ``+=(_:_:)``
- ``-=(_:_:)``

### Distance

- ``magnitude``

### Errors

- ``Error``

### Cross-Domain Scaling

- ``Affine_Primitives_Core/Affine/Discrete/Ratio``
