# Affine

`Affine.Position<Domain>` is a signed discrete coordinate with Int64 storage.
Its `Offset` is `Tagged<Domain, Difference>`, retaining the complete signed
separation of any two coordinates, including the minimum and maximum.

```swift
import Affine
import Difference
import Tagged

enum Document {}
let first = Affine.Position<Document>(rawValue: 3)
let last = Affine.Position<Document>(rawValue: 8)
let offset = first.distance(to: last)
assert(try first.advanced(by: offset) == last)
let translation = Affine.Translation<Document>(offset: offset)
assert(try translation.inverted().applying(to: last) == first)
```

Positions support checked advancement and retreat, and same-domain subtraction.
There is no position-plus-position operation. Translation has identity,
application, inversion, and checked composition. Phantom domains impose no
copyability, escapability, or sendability requirement.

Difference, Ratio, Ordinal, and Interval own their canonical numeric concepts.
The former Affine.Discrete numeric types and Region are removed with breaking
APIs. Ratio now supports exact rational factors; Interval.Discrete owns finite
half-open ordinal intervals.

The calendar-time workspace tests these affine operations and the retained
integration harness. Compile fixtures verify that positions, offsets, and
translations from distinct domains cannot be combined.

## Generic affine points

`Affine.Point<Domain, Translation>` models points over an additive translation type, including scalar coordinates or mathematical vectors. Points share a caller-chosen origin. Translating both points by the same offset preserves their displacement. Offsets retain the phantom Domain; coordinates are not absolute locations shared across domains. Scalar arithmetic determines overflow and numerical precision. There is no point-plus-point operation. Existing Affine.Position retains its checked discrete arithmetic.
