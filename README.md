# Affine

Affine<Point, Displacement, Failure> describes the relationship between independently
owned types: translating a point by a displacement, and measuring the displacement
between two points. Operations can throw a typed error.

It does not own point, coordinate, vector, or translation representations.
It imposes no unconditional numeric, ordering, or sendability constraints.

For a fixed point, displacement-to-point and point-to-displacement operations must
be inverses wherever the chosen representation admits them. Identity and composition
must agree with the displacement algebra. Supplying closures does not prove these
laws; bounded arithmetic also needs an explicit overflow policy.

Concrete composition lives in molecules: swift-point-affine supplies componentwise,
Cartesian, tagged, coordinate-system, and translation adapters; swift-time-affine
supplies temporal composition. This atom has no package dependencies and exports only the Affine library.

## Tests

Tests use only Affine, Swift's standard library, and Swift Testing. They exercise
the two supplied operations, example affine laws, typed failure propagation, and
independently owned point and displacement types. Test names are backticked sentences.

Concrete numeric and tagged integration tests belong with their owning types or
composition molecules, not in this atom. Legacy Foundation Integration and Test
Support products have been removed.
