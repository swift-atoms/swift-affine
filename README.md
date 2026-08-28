# Affine Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A typed affine-displacement primitive — `Affine.Discrete.Vector`, a signed offset between positions, plus `Affine.Discrete.Ratio<From, To>` for typed cross-domain scaling and a phantom-tagged `Tagged<Tag, Ordinal>.Offset` typealias for per-domain offset types.

`Affine.Discrete.Vector` separates *signed offset* from the two other things stdlib calls `Int`: **count** (see [`swift-cardinal`](https://github.com/swift-atoms/swift-cardinal)) and **position** (see [`swift-ordinal`](https://github.com/swift-atoms/swift-ordinal)).

---

## Quick Start

```swift
import Affine

// Bare Vector — a signed displacement
let forward: Affine.Discrete.Vector = 5
let backward: Affine.Discrete.Vector = -3
let combined = forward + backward                          // Vector(2)
let magnitude = forward.magnitude                          // Cardinal(5)

// Phantom-tagged offset paired with a typed ordinal domain
extension Element {}

let step: Tagged<Element, Ordinal>.Offset = 1
let stepBack: Tagged<Element, Ordinal>.Offset = -1
let zero = step + stepBack                                 // Offset(0)

// Affine arithmetic between an Ordinal and a Tagged offset
let position: Tagged<Element, Ordinal> = 5
let next = try position + step                             // Tagged<Element, Ordinal>(6)
let prev = try next - step                                 // Tagged<Element, Ordinal>(5)
let displacement: Tagged<Element, Affine.Discrete.Vector> = try next - prev  // Offset(1)

// Cross-domain ratio — typed scaling between domains
extension Byte {}
extension Bit {}

let bitsPerByte: Affine.Discrete.Ratio<Byte, Bit> = .init(8)
let bytes: Tagged<Byte, Cardinal> = 4
let bits = bytes * bitsPerByte                             // Tagged<Bit, Cardinal>(32)
```

`Affine.Discrete.Vector` is backed by signed `Int`, which makes the displacement representational. The arithmetic surface is partial across three operations: `Position + Vector → Position` (translate), `Position − Vector → Position` (translate the other direction), and `Position − Position → Vector` (the displacement between positions). Each may throw a typed error: `Ordinal.Error` for `UInt` over/underflow on the position side, `Affine.Discrete.Vector.Error.unrepresentable` for `Int` representation overflow on the displacement side.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-affine.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Affine", package: "swift-affine"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Five library products covering the namespace, the bare types, the standard-library integration, the umbrella, and a Test Support target.

| Product | Target | Purpose |
|---------|--------|---------|
| `Affine Primitives` | `Sources/Affine Primitives/` | Umbrella — re-exports and Standard Library Integration; the default import for application code. |
| `Affine Primitives Core` | `Sources/Affine Primitives Core/` | The `Affine.Discrete.Vector` and `Affine.Discrete.Ratio<From, To>` types — backing `Int` storage, generic `Position ± Vector` and `Position − Position` operators with typed throws, the `Tagged<Tag, Ordinal>.Offset` typealias, and `Affine.Discrete.Vector.Error`. |
| `Affine Standard Library Integration` | `Sources/Affine Standard Library Integration/` | Conformances and integration overloads bridging Affine into the standard library: `Int(bitPattern:)` for both bare `Vector` and `Tagged<Tag, Vector>`, `RandomAccessCollection.index(_:offsetBy:)` accepting typed offsets, and `UnsafePointer` / `UnsafeMutablePointer` arithmetic (`+`, `-`) typed by `Tagged<Pointee, Ordinal>.Offset`. |
| `Affine Namespace` | `Sources/Affine Namespace/` | Empty `public enum Affine {}` namespace — separated so a consumer that only needs the namespace declaration (e.g., for cross-package extensions) does not pull the arithmetic surface. |
| `Affine Test Support` | `Tests/Support/` | Re-exports the umbrella + cardinal / ordinal Test Support fixtures for downstream test consumers. |

Import the narrowest product you need: `Affine Primitives Core` for just the types, `Affine Primitives` (the umbrella) for the full surface including Standard Library Integration bridges and re-exported Cardinal / Ordinal / Carrier / Equation / Comparison.

The package depends on five primitives — `swift-ordinal`, `swift-cardinal`, `swift-carrier`, `swift-equation`, `swift-comparison`. See [Related Packages](#related-packages).

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support (CI matrix) |
| Windows | Full support (CI matrix) |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported (no concurrency surface, no Foundation) |

---

## Related Packages

Direct dependencies:

- [swift-ordinal](https://github.com/swift-atoms/swift-ordinal) — cohort sibling, providing `Ordinal` (position). Position ± Vector arithmetic is the central affine operation; the generic `Ordinal.\`Protocol\` ± Carrier.\`Protocol\`<Affine.Discrete.Vector>` operators dispatch through `Ordinal.\`Protocol\``.
- [swift-cardinal](https://github.com/swift-atoms/swift-cardinal) — cohort sibling, providing `Cardinal` (count). Vector magnitude is a Cardinal; cross-domain ratio scaling on Tagged Cardinals goes through `Affine.Discrete.Ratio<From, To>`.
- [swift-carrier](https://github.com/swift-atoms/swift-carrier) — provides `Carrier.\`Protocol\`<Underlying>`, the unified super-protocol `Affine.Discrete.Vector` conforms to as a trivial self-carrier (`Underlying = Affine.Discrete.Vector`). The carrier conformance is the bridge that lets a `Tagged<Tag, Affine.Discrete.Vector>` reuse Vector's arithmetic uniformly.
- [swift-equation](https://github.com/swift-atoms/swift-equation) — provides `Equation.\`Protocol\``, the `Equatable`-shape conformance Vector exposes.
- [swift-comparison](https://github.com/swift-atoms/swift-comparison) — provides `Comparison.\`Protocol\``, the `Comparable`-shape conformance Vector exposes.

Companion primitives covering the other two things stdlib calls `Int`:

- [swift-cardinal](https://github.com/swift-atoms/swift-cardinal) — `Cardinal`, a non-negative count.
- [swift-ordinal](https://github.com/swift-atoms/swift-ordinal) — `Ordinal`, a non-negative position in a 0-indexed sequence.

---

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
