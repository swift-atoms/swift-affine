# swift-affine

Use `Affine` when two types stand in a point–displacement relation (a reading and a change, an instant and a duration, a position and an offset) and you need to move a point by a displacement, or measure the displacement between two points, without making either type conform to a protocol.

## Model

`Affine<Point, Displacement, Failure>` is a value that holds two operations, not a protocol, so one pair of types can have several relationships and neither type needs to know about any of them.

- `translated(_:by:)`: point + displacement → point.
- `displacement(from:to:)`: point − point → displacement, measured from `start` to `end`.

Both throw `Failure`. Use `Never` when the arithmetic cannot fail, and a domain error when it can (overflow, out of range).

## Laws

A relationship you build must satisfy these; the package's tests check them for its own:

- Translating by zero leaves a point unchanged, and the displacement from a point to itself is zero.
- `translated(start, by: displacement(from: start, to: end)) == end`.
- Displacements compose: start→middle plus middle→end equals start→end.

## Variants

- `tagged(Tag.self)`, with trait `Tagged`: the same relationship over `Tagged<Tag, Point>`, so points from different domains can't be mixed while displacements stay plain.
- `Affine.componentwise(...)`, with trait `Vector`: an N-dimensional relationship built from a per-component one, through `Vector<N, Scalar>`.

## Example

```swift
let readings = Affine<Reading, Int, Never>(
    translating: { Reading(value: $0.value + $1) },
    displacement: { $1.value - $0.value }
)
readings.translated(Reading(value: 7), by: 3)                           // Reading(value: 10)
readings.displacement(from: Reading(value: 7), to: Reading(value: 10))  // 3
```
