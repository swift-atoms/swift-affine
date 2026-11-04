# swift-affine

Use this package when two types you do not own, or do not want to change, stand in a point-displacement relation (a reading and a change, an instant and a `Swift::Duration`, a position and an offset) and you need to move a point by a displacement or measure the displacement between two points. Start from `Affine<Point, Displacement, Failure>`: it is a value holding the two operations, not a protocol the types conform to, so one pair of types can carry several relationships and neither type knows about any of them.

## Laws

- A relationship must satisfy the affine laws; nothing checks them at construction, and the tests check them only for their own relationships:
  - translating a point by the zero displacement returns the same point, and the displacement from a point to itself is zero;
  - `translated(start, by: displacement(from: start, to: end)) == end`, and translating `end` by the negated displacement returns `start`;
  - displacements compose: the displacement from start to end equals the displacement from start to middle plus the displacement from middle to end, and translating by two displacements in turn equals translating once by their sum.
- Displacement is directed: `displacement(from: start, to: end)` is `end − start`, and swapping the arguments negates it.
- Nothing is cached: every call runs the supplied closure afresh. `translated(_:by:)` runs only the translating closure and `displacement(from:to:)` runs only the displacement closure, and each rethrows its closure's failure unchanged.
- `tagged(_:)` neither checks nor transforms the tag: it unwraps the points, runs the underlying relationship, and rewraps the translated point under the same tag. Displacements stay untagged, so the same displacement applies in every tagged domain.
- `componentwise(...)` works independently per component: each component of the result depends only on the same component of the inputs, and a failure in any component fails the whole operation.
